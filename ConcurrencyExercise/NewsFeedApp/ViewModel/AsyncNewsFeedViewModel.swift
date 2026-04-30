//
//  AsyncNewsFeedViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 4/30/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class AsyncNewsFeedViewModel {
	
	enum NetworkError: Error {
		case invalidURL(message: String)
		case invalidNetworking(message: String)
		case invalidResponse(message: String)
		case noDataError(message: String)
		case dataParsingError(message: String)
	}
	
	private let endpoint: String = "https://jsonplaceholder.typicode.com/posts"
	
	var asyncNews: [NewsItem] = []
	var isloading: Bool = false
	var errorMessage: String? = nil
	
	func asyncFetchNews() async {
		guard let url = URL(string: endpoint) else {
			self.errorMessage = "URL 에러"
			self.isloading = false
			return
		}
		self.isloading = true
		do {
			try await asyncFetchData(url: url)
		} catch let error as NetworkError {
			switch error {
			case .invalidResponse(let message): self.errorMessage = message
			case .dataParsingError(let message): self.errorMessage = message
			default: self.errorMessage = "네트워크 오류: \(error.localizedDescription)"
			}
		} catch {
			self.errorMessage = "알 수 없는 오류: \(error)"
		}
		self.isloading = false
	}
	
	func asyncFetchData(url: URL) async throws {

		let (data, response) = try await URLSession.shared.data(from: url)
		guard let res = response as? HTTPURLResponse,
			  res.statusCode >= 200 && res.statusCode < 300 else {
			throw NetworkError.invalidResponse(message: "서버 응답 에러")
		}
		do {
			let result = try JSONDecoder().decode([NewsItem].self, from: data)
			self.asyncNews = result
		} catch {
			throw NetworkError.dataParsingError(message: "데이터 파싱 에러")
		}
	}
}
