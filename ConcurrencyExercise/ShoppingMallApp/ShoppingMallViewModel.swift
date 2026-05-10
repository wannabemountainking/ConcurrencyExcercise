//
//  ShoppingMallViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/10/26.
//

import Foundation
import Observation


struct Product: Identifiable {
	let id = UUID()
	let name: String
	let price: Int
	var result: String = ""
}

enum PriceError: Error {
	case fetchFailed
}

let products: [Product] = [
	Product(name: "MacBook Pro", price: 3_000_000),
	Product(name: "iPhone 15",   price: 1_200_000),
	Product(name: "AirPods Pro", price: 350_000),
	Product(name: "Apple Watch", price: 550_000),
	Product(name: "iPad Pro",    price: 1_500_000),
	Product(name: "Mac mini",    price: 900_000),
	Product(name: "Studio Display", price: 2_200_000),
	Product(name: "Magic Keyboard", price: 180_000),
]


@MainActor
@Observable
final class ShoppingMallViewModel {
	var priceResults: [String] = []
	var totalPrice: Int = 0
	var isLoading: Bool = false
	var elapsedTime: String = ""
	
	init() {
		Task {
			await fetchAllPrices()
		}
	}
	
	func fetchAllPrices() async {
		let startTime = Date()
		self.priceResults = []
		self.totalPrice = 0
		self.isLoading = true
		await withTaskGroup(of: Product.self) { group in
			for product in products {
				group.addTask {
					do {
						return try await self.fetchPrice(product)
					} catch let error as PriceError {
						switch error {
						case .fetchFailed:
							return Product(
								name: product.name,
								price: 0,
								result: "❌ \(product.name): 조회 실패"
							)
						}
					} catch {
						return Product(
							name: product.name,
							price: 0,
							result: error.localizedDescription
						)
					}
				}
			}
			
			for await result in group {
				if result.result.isEmpty {
					self.priceResults.append("❌ \(result.name): 알려지지 않은 에러")
				} else {
					self.priceResults.append(result.result)
					self.totalPrice += result.price
				}
			}
		}
		self.isLoading = false
		self.elapsedTime = "\(Date().timeIntervalSince(startTime).formatted(.number.precision(.fractionLength(2))))초"
	}
	
	private func fetchPrice(_ product: Product) async throws -> Product {
		try? await Task.sleep(for: .milliseconds(500))
		if Bool.random() {
			throw PriceError.fetchFailed
		} else {
			var renewed = Product(name: product.name, price: product.price)
			if product.price == 0 {
				renewed.result = "품절"
			} else {
				renewed.result = "✅ \(product.name): \(product.price.decimalNumber)원"
			}
			return renewed
		}
	}
}


