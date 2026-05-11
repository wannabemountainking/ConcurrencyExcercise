//
//  NewsStreamManager.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/12/26.
//

import Foundation
import Combine


final class NewsStreamManager {
    
    let newsService = FakeNewsService.shared
    private var continuation: AsyncStream<String>.Continuation?
    
    init() { }
    
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
        guard self.continuation == nil else {return}
        
        self.newsService.connect { [weak self] newsHeadline in
            guard let self else {return}
            self.continuation?.yield(newsHeadline)
        }
    }
    
    func disconnect() {
        guard self.continuation != nil else {return}
        self.newsService.disconnect()
        self.continuation = nil
    }
}
