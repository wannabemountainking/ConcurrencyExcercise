//
//  FileDownloadViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/10/26.
//

import Foundation
import Observation


enum DownloadError: Error {
	case timeout
	case serverError
	case cancelled
}

@MainActor
@Observable
final class FileDownloadViewModel {
	
	var result: String = ""
	var errorMessage: String = ""
	var isLoading: Bool = false
	
	init() {
		Task {
			await downloadFile(fileName: "SwiftConcurrency.pdf")
		}
	}
	
	func downloadFile(fileName: String) async {
		self.isLoading = true
		self.result = ""
		self.errorMessage = ""
		
		do {
			let downloadResult: String = try await withCheckedThrowingContinuation { continuation in
				downloadFileWithCallBack(fileName: fileName) { result in
					continuation.resume(with: result)
				}
			}
			self.result = downloadResult
			self.errorMessage = ""
		} catch let error as DownloadError {
			switch error {
			case .timeout:
				self.errorMessage = "다운로드 시간 초과"
			case .serverError:
				self.errorMessage = "서버 에러"
			case .cancelled:
				self.errorMessage = "취소"
			}
		} catch {
			self.errorMessage = error.localizedDescription
		}
		self.isLoading = false
	}
	
	private func downloadFileWithCallBack(
		fileName: String,
		completion: @escaping (Result<String, DownloadError>) -> Void
	) {
		let delay = Double.random(in: 1...7)
		DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
			if delay > 5 {
				completion(.failure(.timeout))
			} else if delay > 4 {
				completion(.failure(.serverError))
			} else if delay > 3 {
				completion(.failure(.cancelled))
			} else {
				completion(.success("✅ \(fileName) 다운로드 완료"))
			}
		}
	}
}
