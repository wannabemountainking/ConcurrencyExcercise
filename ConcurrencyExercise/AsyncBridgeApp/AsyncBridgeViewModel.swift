//
//  AsyncBridgeViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/10/26.
//

import Foundation
import Observation


enum LocationError: Error {
	case permissionDenied
	case locationUnavailable
}

@MainActor
@Observable
final class AsyncBridgeViewModel {
	
	var location: String = ""
	var errorMessage: String = ""
	var isLoading: Bool = false
	
	init() {
		Task {
			await fetchLocation()
		}
	}
	
	func fetchLocation() async {
		self.isLoading = true
		do {
			let locationResult: String = try await withCheckedThrowingContinuation { continuation in
				fetchLocationWithCallBack { result in
					continuation.resume(with: result)
				}
			}
			self.location = locationResult
			self.errorMessage = ""
		} catch let error as LocationError {
			switch error {
			case .permissionDenied:
				self.errorMessage = "위치 서비스 사용 불허"
			case .locationUnavailable:
				self.errorMessage = "위치 서비스 사용 불가"
			}
		} catch {
			self.errorMessage = error.localizedDescription
		}
		self.isLoading = false
	}
	
	private func fetchLocationWithCallBack(completion: @escaping (Result<String, LocationError>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
			if Bool.random() {
				completion(.success("위도: 37.5665, 경도: 126.9780"))
			} else {
				completion(.failure(LocationError.permissionDenied))
			}
		}
	}
}

