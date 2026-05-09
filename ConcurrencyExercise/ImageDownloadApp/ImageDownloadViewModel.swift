//
//  ImageDownloadViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/9/26.
//

import Foundation
import SwiftUI
import Observation

// 더미 데이터
let imageURLs = [
	"https://picsum.photos/200",
	"https://picsum.photos/201",
	"https://picsum.photos/202",
	"https://picsum.photos/203",
	"https://picsum.photos/204",
	"https://picsum.photos/205",
	"https://picsum.photos/206",
	"https://picsum.photos/207",
	"https://picsum.photos/208",
	"https://picsum.photos/209"
]

enum NetworkError: Error {
	case invalidURL
	case invalidResponse
	case parsingError
}

@MainActor
@Observable
final class ImageDownloadViewModel {
	
	var results: [String] = []
	var isLoading: Bool = false
	var elapedTime: String = ""
	
	init() {
		
	}
	
	func downloadAll() async {
		await withTaskGroup(of: [String].self) { group in
			<#code#>
		}
	}
	
	private func fetchPhoto(urlString: String) async throws -> Image {
		guard let url = URL(string: urlString) else {
			throw NetworkError.invalidURL
		}
		do {
			let (imageData, response) = try await URLSession.shared.data(from: url)
			guard let res = response as? HTTPURLResponse,
				  res.statusCode >= 200 && res.statusCode < 300 else {
				throw NetworkError.invalidResponse
			}
			guard let data = UIImage(data: imageData) else { throw NetworkError.parsingError }
			return Image(uiImage: data)
		} catch {
			print(error)
		}
	}
}
