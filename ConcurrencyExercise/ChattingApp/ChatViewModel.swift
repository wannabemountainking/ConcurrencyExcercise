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
	
	let manager = ChatSocketManager.shared
	
	var messages: [ChatMessage] = []
	var isConnected: Bool = false
	
	init() {
	}
	
	func connect() async {
		self.isConnected = false
		let stream = manager.makeStream()
		await manager.connect()
		for await result in stream {
			self.messages.insert(result, at: 0)
		}
		self.isConnected = true
	}
	
	func disConnect() {
		manager.disconnect()
	}
}
