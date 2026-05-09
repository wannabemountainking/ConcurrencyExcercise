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
	case imageDownloadFailed
}

@MainActor
@Observable
final class ImageDownloadViewModel {
	
	var results: [String] = []
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
        
        await withTaskGroup(of: String?.self, returning: Void.self) { [weak self] group in
            guard let self else {return}
            for imageURL in imageURLs {
                group.addTask {
                    do {
                        return try await self.fetchPhoto(url: imageURL)
                    } catch {
                        print("이미지 다운로드 실패 에러")
                    }
                    return nil
                }
                
                for await result in group {
                    guard let result else { continue }
                    self.results.append(result)
                }
            }
        }
        
        self.isLoading = false
        self.elapedTime = "\(Date().timeIntervalSince(startTime).formatted(.number.precision(.fractionLength(2))))초"
	}
	
	private func fetchPhoto(url: String) async throws -> String {
        try? await Task.sleep(for: .seconds(1))
        if Bool.random() {
            return "✅ \(url) 완료"
        } else {
            return "❌ \(url) 실패"
        }
	}
}
