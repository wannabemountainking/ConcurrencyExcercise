//
//  TimerViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/11/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class TimerViewModel {
	
	let timerManager = TimerManager.shared
	
	var count: Int = 0
	var timestamp: String = ""
	var isRunning: Bool = false
	
	init() {
		
	}
	
	func startTimer() async {
		self.isRunning = true
		let stream = timerManager.makeStream()
		timerManager.start()
		for await result in stream {
			self.count = result.count
			self.timestamp = result.timestamp.timeOnly
		}
	}
	
	func stopTimer() {
		timerManager.stop()
		self.isRunning = false
	}
}

extension Date {
	var timeOnly: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH시 mm분 ss초"
		return formatter.string(from: self)
	}
}
