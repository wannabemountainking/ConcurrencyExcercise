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
	
	private let endpoint: String = "https://jsonplaceholder.typicode.com/posts"
	
	var news: [NewsItem] = []
	var isloading: Bool = false
	var errorMessage: String? = nil
	
	init() {
		fetchNews()
	}
	
	func fetchNews()  {
		guard let url = URL(string: endpoint) else {
			self.errorMessage = "URL 오류"
			self.isloading = false
			return
		}
		
		self.isloading = true
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, res, error in
			guard let self else {return}
			guard error == nil else {
				self.errorMessage = "url Session 에러"
				self.isloading = false
				return
			}
			guard let response = res as? HTTPURLResponse,
				  response.statusCode == 200 else {
				self.errorMessage = "서버 응답 오류"
				self.isloading = false
				return
			}
			guard let safeData = data,
				  let result = try? JSONDecoder().decode([NewsItem].self, from: safeData) else {
				self.errorMessage = "데이터 파싱 오류"
				self.isloading = false
				return
			}
			
			self.news.append(contentsOf: result)
			self.isloading = false
		}
		task.resume()
	}
}
