//
//  NewsStreamManager.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/12/26.
//

import Foundation
import Combine


final class NewsStreamManager {
    
	static let shared = NewsStreamManager()
	
    let newsService = FakeNewsService.shared
    private var continuation: AsyncStream<String>.Continuation?
    
    private init() { }
    
    func makeStream() -> AsyncStream<String> {
        return AsyncStream { streamHandler in
            self.continuation = streamHandler
            streamHandler.onTermination = { [weak self] _ in
                guard let self else {return}
                Task { @MainActor in
                    self.disconnect()
                }
            }
        }
    }
    
    func connect() {
		guard self.continuation != nil else {return}
        self.newsService.connect { [weak self] headline in
            guard let self else {return}
            self.continuation?.yield(headline)
			print(headline)
        }
    }
    
    func disconnect() {
        guard self.continuation != nil else {return}
        self.newsService.disconnect()
		
		self.continuation?.finish()
        self.continuation = nil
    }
}
