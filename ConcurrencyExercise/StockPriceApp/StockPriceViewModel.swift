//
//  StockPriceViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/10/26.
//

import Foundation
import Observation


struct StockPrice: Identifiable {
	let id = UUID()
	let price: Double
	let change: Double // 전일 대비
	
	static let symbol: String = "AAPL"
}

@MainActor
@Observable
final class StockPriceViewModel {
	var currentPrice: Double = 0.0
	var change: Double = 0.0
	var priceHistory: [StockPrice] = []
	var isStreaming: Bool = false
	
	init() {
		Task {
			await startStream()
		}
	}
	
	func startStream() async {
		self.isStreaming = true
		for await stockPrice in stockPriceStream() {
			self.priceHistory.append(stockPrice)
			self.currentPrice = stockPrice.price
			self.change = stockPrice.change
		}
		self.isStreaming = false
	}
	
	private func stockPriceStream() -> AsyncStream<StockPrice> {
		return AsyncStream { continuation in
			Task {
				var basePrice = 150.0
				for _ in 1...10 {
					try? await Task.sleep(for: .seconds(1))
					let change = Double.random(in: -5...5)
					basePrice += change
					let stockPrice = StockPrice(
						price: basePrice,
						change: change
					)
					continuation.yield(stockPrice)
				}
				continuation.finish()
			}
		}
	}
}
