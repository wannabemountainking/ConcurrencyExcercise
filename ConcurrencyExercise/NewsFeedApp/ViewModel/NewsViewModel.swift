//
//  NewsViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 4/30/26.
//

import Foundation
import Observation


@Observable
final class NewsViewModel {
	enum NetworkError: Error {
		case invalidURL(message: String)
		case invalidNetworking(message: String)
		case invalidResponse(message: String)
		case noDataError(message: String)
		case dataParsingError(message: String)
	}
	
	private let endpoint: String = "https://jsonplaceholder.typicode.com/posts"
	
	var news: [NewsItem] = []
	var isloading: Bool = false
	var errorMessage: String? = nil
	
	func fetchNews() {
		guard let url = URL(string: endpoint) else {
			DispatchQueue.main.async {
				self.errorMessage = "URL 에러"
				self.isloading = false
			}
			return
		}
		self.isloading = true
		fetchData(url: url) { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let newsItems):
					self.news = newsItems
					self.isloading = false
					self.errorMessage = nil
				case .failure(let error):
					self.isloading = false
					switch error {
					case .invalidURL(let msg): self.errorMessage = msg
					case .invalidNetworking(let msg): self.errorMessage = msg
					case .invalidResponse(let msg): self.errorMessage = msg
					case .noDataError(let msg): self.errorMessage = msg
					case .dataParsingError(let msg): self.errorMessage = msg
					}
				}
			}
		}
	}
	
	func fetchData(url: URL, completion: @escaping (Result<[NewsItem], NetworkError>) -> Void) {
		URLSession.shared.dataTask(with: url) { data, res, error in
			guard error == nil else {
				completion(.failure(.invalidNetworking(message: "네트워크 에러")))
				return
			}
			guard let response = res as? HTTPURLResponse,
				  response.statusCode == 200 else {
				completion(.failure(.invalidResponse(message: "서버 응답 에러")))
				return
			}
			guard let safeData = data else {
				completion(.failure(.noDataError(message: "수신 데이터가 없습니다")))
				return
			}
			do {
				let result = try JSONDecoder().decode([NewsItem].self, from: safeData)
				completion(.success(result))
				return
			} catch {
				completion(.failure(.dataParsingError(message: "데이터 파싱 에러")))
				return
			}
		}.resume()
	}
}
