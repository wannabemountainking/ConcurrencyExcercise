//
//  TranslationService.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/12/26.
//

import Foundation


final class TranslationService {
    let transService = FakeTranslationService.shared
    
    init() {}
    
    func translate(text: String, language: String) async throws -> String {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {return}
            self.transService.translateWithCallBack(text: text, language: language) { result in
                
            }
        }
    }
}
