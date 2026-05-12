//
//  TranslationService.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/12/26.
//

import Foundation


final class TranslationService {
	
	static let shared = TranslationService()
	
    let transService = FakeTranslationService.shared
    
    private init() {}
    
    func translate(text: String, language: String) async throws -> String {
		try await withCheckedThrowingContinuation { continuation in
			self.transService.translateWithCallBack(text: text, language: language) { result in
				switch result {
				case .success(let title):
					continuation.resume(returning: title)
				case .failure(let error):
					continuation.resume(throwing: error)
				}
			}
		}
    }
}
