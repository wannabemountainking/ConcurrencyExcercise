//
//  NewViewModel.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/12/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class TopicViewModel {
	
	let newsManager = NewsStreamManager.shared
	let translationService = TranslationService.shared
	
	var newsHeadlines: [NewsHeadline] = []
	var isLoading: Bool = false
	
	init() {
	}
	
	func connect() async {
		self.isLoading = true
		let stream = newsManager.makeStream()
		self.newsManager.connect()
		for await headlineString in stream {
			let traslatedText = await asyncTranslation(headline: headlineString, languages: ["영어", "중국어", "일본어"])
			let newsHeadline = NewsHeadline(original: headlineString, translations: traslatedText)
			self.newsHeadlines.insert(newsHeadline, at: 0)
		}
		self.isLoading = false
	}
	
	func disconnect() {
		self.newsManager.disconnect()
		self.isLoading = false
	}
	
	private func asyncTranslation(headline: String, languages: [String]) async -> [NewsHeadline.Language] {
		var translatedLanguages: [NewsHeadline.Language] = []
		return await withTaskGroup(of: NewsHeadline.Language.self) { group in
			for language in languages {
				group.addTask {
					do {
						let translation = try await self.translationService.translate(text: headline, language: language)
						return NewsHeadline.Language(name: language, translated: translation)
					} catch let error as TranslationError {
						switch error {
						case .notFound:
							return NewsHeadline.Language(name: language, translated: "번역 내용이 없습니다")
						case .networkError:
							return NewsHeadline.Language(name: language, translated: "네트워크 오류")
						}
					} catch {
						return NewsHeadline.Language(name: language, translated: "알 수 없는 에러: \(error.localizedDescription)")
					}
				}
			}
			
			for await translated in group {
				translatedLanguages.append(translated)
			}
			return translatedLanguages
		}
	}
	
}
