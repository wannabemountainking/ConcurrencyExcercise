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
	case parsingError
	case invalidResponse
	case URLSessionError
	case unknownError
}

enum ImageError: Error {
	case uiImageToImageError
}

struct ImageResult: Identifiable {
	let id = UUID()
	let urlString: String
	let image: Image
}

@MainActor
@Observable
final class ImageDownloadViewModel {
	
	var results: [ImageResult] = []
	var isLoading: Bool = false
	var elapedTime: String = ""
	
	init() {
        Task {
            await downloadAll()
        }
	}
	
	func downloadAll() async {
        let startTime = Date()
        self.isLoading = true
		self.results = []
		await withTaskGroup(of: ImageResult.self) { group in
            for imageURL in imageURLs {
                group.addTask {
					await self.safelyFetchPhoto(urlString: imageURL)
                }
            }
			for await result in group {
				self.results.append(result)
			}
        }
        
        self.isLoading = false
        self.elapedTime = "\(Date().timeIntervalSince(startTime).formatted(.number.precision(.fractionLength(2))))초"
	}
	
	private func safelyFetchPhoto(urlString: String) async -> ImageResult {
		do {
			return try await fetchPhoto(urlString: urlString)
		} catch let err as NetworkError {
			switch err {
			case .invalidURL:
				return ImageResult(
					urlString: "URL 에러",
					image: Image(systemName: "photo.trianglebadge.exclamationmark")
				)
			case .parsingError:
				return ImageResult(
					urlString: "데이터 파싱 에러",
					image: Image(systemName: "photo.trianglebadge.exclamationmark")
				)
			case .invalidResponse:
				return ImageResult(
					urlString: "서버 응답 에러",
					image: Image(systemName: "photo.trianglebadge.exclamationmark")
				)
			case .URLSessionError:
				return ImageResult(
					urlString: "URLSession 에러",
					image: Image(systemName: "photo.trianglebadge.exclamationmark")
				)
			case .unknownError:
				let failedImage = Image(systemName: "photo.trianglebadge.exclamationmark")
				return ImageResult(
					urlString: "알 수 없는 이유로 다운로드 실패",
					image: failedImage
				)
			}
			 
		} catch let error as ImageError {
			switch error {
			case .uiImageToImageError:
				return ImageResult(
					urlString: "UIImage -> Image로 변환 실패",
					image: Image(systemName: "square.and.arrow.down.badge.xmark")
				)
			}
			 
		} catch {
			return ImageResult(
				urlString: "이미지 저장 실패",
				image: Image(systemName: "square.and.arrow.down.badge.xmark")
			)
		}
	}
	
	private func fetchPhoto(urlString: String) async throws -> ImageResult {
        if Bool.random() {
			guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
			let (data, response) = try await URLSession.shared.data(from: url)
			guard let res = response as? HTTPURLResponse,
				  res.statusCode >= 200 && res.statusCode < 300 else {
				throw NetworkError.invalidResponse
			}
			guard let uiImage = UIImage(data: data) else { throw ImageError.uiImageToImageError }
			let result = ImageResult(
				urlString: "✅ \(urlString) 완료",
				image: Image(uiImage: uiImage)
			)
			return result
        } else {
			throw NetworkError.unknownError
        }
	}
}
