//
//  NewsService.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/12/26.
//

import Foundation

// NewsService
struct NewsHeadline: Identifiable {
    let id = UUID()
    let original: String
    var translations: [Language]
	
	struct Language {
		let name: String
		var translated: String
	}
}

// 콜백 기반 뉴스 서비스 (변경 불가)
final class FakeNewsService {
    static let shared = FakeNewsService()
    private var timer: Timer?
    private let headlines = [
        "애플, 새로운 아이폰 발표",
        "삼성, 폴더블폰 신제품 출시",
        "Swift 6.0 정식 출시",
        "AI 기술 혁신 가속화",
        "우주 탐사 새로운 발견"
    ]
    
    private init() { }
    
    func connect(onNews: @escaping (String) -> Void) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { [weak self] _ in
            guard let self else {return}
            onNews(self.headlines.randomElement() ?? "오류")
        })
    }
    
    func disconnect() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

// translationService
enum TranslationError: Error {
    case notFound
    case networkError
}

final class FakeTranslationService {
    
    static let shared = FakeTranslationService()
    
    private init() { }
    
    func translateWithCallBack(text: String, language: String, completion: @escaping (Result<String, TranslationError>) -> Void) {
        let translations: [String: [String : String]] = [
            "애플, 새로운 아이폰 발표": [
                "영어": "Apple announces new iPhone",
                "일본어": "アップル、新しいiPhoneを発表",
                "중국어": "苹果发布新款iPhone"
            ],
            "삼성, 폴더블폰 신제품 출시": [
                "영어": "Samsung launches neㅜ foldable phone",
                "일본어": "サムスン、新型折りたたみスマホを発売",
                "중국어": "三星推出新款折叠屏手机"
            ],
            "Swift 6.0 정식 출시": [
                "영어": "Swift 6.0 officially released",
                "일본어": "Swift 6.0が正式リリース",
                "중국어": "Swift 6.0正式发布"
            ],
            "AI 기술 혁신 가속화": [
                "영어": "AI technology innovation accelerates",
                "일본어": "AI技術革新が加速",
                "중국어": "AI技术创新加速"
            ],
            "우주 탐사 새로운 발견": [
                "영어": "New discovery in space exploration",
                "일본어": "宇宙探査で新たな発見",
                "중국어": "太空探索新发现"
            ]
        ]
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if let translation = translations[text]?[language] {
                completion(.success(translation))
            } else {
                completion(.failure(.notFound))
            }
        }
    }
}



