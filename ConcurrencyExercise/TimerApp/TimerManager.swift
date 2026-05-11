//
//  TimerManager.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/11/26.
//

import Foundation
import Combine

struct TimerTick {
	let count: Int   // 몇 번째 틱인지(1, 2, 3, ...)
	let timestamp: Date // 언제 발생했는지
}

final class TimerManager {
	
	static let shared = TimerManager()
	
	private var continuation: AsyncStream<TimerTick>.Continuation?
	private var cancellable: Cancellable?
	
	private init() { }
	
	func makeStream() -> AsyncStream<TimerTick> {
		return AsyncStream { streamHandle in
			self.continuation = streamHandle
			streamHandle.onTermination = { [weak self] termination in
				guard let self else {return}
				Task { @MainActor in
					self.stop()
					print("흐름 종료", termination)
				}
			}
		}
	}
	
	func start() {
		guard cancellable == nil else {return}
		
		cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
			.autoconnect()
			.scan(0) { count, _ in return count + 1 }
			.map { TimerTick(count: $0, timestamp: Date()) }
			.sink { [weak self] timerTick in
				guard let self else {return}
				self.continuation?.yield(timerTick)
			}
	}
	
	func stop() {
		self.cancellable?.cancel()
		self.cancellable = nil
		
		self.continuation?.finish()
		self.continuation = nil
	}
}
