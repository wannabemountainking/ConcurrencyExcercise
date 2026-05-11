//
//  ChatViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/11/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class ChatViewModel {
	
	let service = FakeSocketService.shared
	
	var messages: [ChatMessage] = []
	var isConnected: Bool = false
	
	init() {
	}
	
	func connect() async {
		self.isConnected = true
        let stream = service.makeStream()
        service.connect()
		for await result in stream {
			self.messages.insert(result, at: 0)
		}
		self.isConnected = false
	}
	
	func disConnect() {
		service.disconnect()
	}
}
