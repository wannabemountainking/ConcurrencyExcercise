//
//  InitViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/8/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class InitViewModel {
	var userName: String
	var theme: String
	var notificationCount: Int
	var isLoading: Bool
	var elapsedTime: String = ""
	
	init(userName: String = "", theme: String = "", notificationCount: Int = 0, isLoading: Bool = false) {
		self.userName = userName
		self.theme = theme
		self.notificationCount = notificationCount
		self.isLoading = isLoading
	}
	
	func initializeAsyncLet() async {
		let startTime = Date()
		self.isLoading = true
		
		async let name = self.fetchUser()
		async let config = self.fetchConfig()
		async let noti = self.fetchNotifications()
		
		(self.userName, self.theme, self.notificationCount) = await (name, config, noti)
		
		self.isLoading = false
		self.elapsedTime = Date().timeIntervalSince(startTime).formatted(.number.precision(.fractionLength(2)))
	}
	
	func initializeTask() async {
		let startTime = Date()
		self.isLoading = true
		self.userName = await self.fetchUser()
		self.theme = await self.fetchConfig()
		self.notificationCount = await self.fetchNotifications()
		self.isLoading = false
		self.elapsedTime = Date().timeIntervalSince(startTime).formatted(.number.precision(.fractionLength(2)))
	}
	
	// 각각 다른 타입 반환 — 1초 딜레이
	private func fetchUser() async -> String {
		try? await Task.sleep(for: .seconds(1))
		return "Jacob"
	}

	private func fetchConfig() async -> String {
		try? await Task.sleep(for: .seconds(1))
		return "다크모드"
	}

	private func fetchNotifications() async -> Int {
		try? await Task.sleep(for: .seconds(1))
		return 5
	}
}
