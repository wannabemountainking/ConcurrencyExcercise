//
//  ChatSocketManager.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/11/26.
//

import Foundation
import Combine


struct ChatMessage: Identifiable {
	let id = UUID()
	let sender: String
	let content: String
	let receivedAt: Date
}

// 기존 콜백 기반 소켓 API
final class FakeSocketService {
	static let shared = FakeSocketService()
	
    private var continuation: AsyncStream<ChatMessage>.Continuation?
    private var cancellable: Cancellable?
	private let senders: [String] = ["Jacob", "Allen", "Yoonie", "Swift", "Claude"]
	private let messages = [
		"안녕하세요!", "오늘 날씨 좋네요",
		"Swift Concurrency 어렵다...",
		"AsyncStream 이해했어요!",
		"다음 강의는 언제인가요?"
	]
	
	private init() {}
	
    func makeStream() -> AsyncStream<ChatMessage> {
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
    
	// 연결
	func connect() {
        guard cancellable == nil else {return}
        cancellable = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .map { _ in
                return ChatMessage(
                    sender: self.senders.randomElement() ?? "나",
                    content: self.messages.randomElement() ?? "통신 오류",
                    receivedAt: Date()
                )
            }
            .sink { [weak self] chatMessage in
                guard let self else {return}
                self.continuation?.yield(chatMessage)
            }
	}
	
	// 연결 해제
	func disconnect() {
        self.cancellable?.cancel()
        self.cancellable = nil
        
        self.continuation?.finish()
        self.continuation = nil
	}
}

//final class ChatSocketManager {
//	
//	static let shared = ChatSocketManager()
//	
//	let service = FakeSocketService.shared
//	
//	private var continuation: AsyncStream<ChatMessage>.Continuation?
//	
//	private init() {}
//	
//	func makeStream() -> AsyncStream<ChatMessage> {
//		return AsyncStream { streamHandler in
//			self.continuation = streamHandler
//			
//			streamHandler.onTermination = { [weak self] _ in
//				guard let self else {return}
//				Task { @MainActor in
//					self.disconnect()
//				}
//			}
//		}
//	}
//	
//	func connect() async {
//		guard self.continuation != nil else {return}
//		
//		service.connect { [weak self] message in
//			guard let self else {return}
//			self.continuation?.yield(message)
//		}
//	}
//	
//	func disconnect() {
//		self.continuation?.finish()
//		self.continuation = nil
//		self.service.disconnect()
//	}
//}
