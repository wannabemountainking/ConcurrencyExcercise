//
//  StockPriceView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/10/26.
//

import SwiftUI

struct StockPriceView: View {
	@State private var vm: StockPriceViewModel = .init()
	
    var body: some View {
		VStack {
			Spacer()
			Text(StockPrice.symbol)
			Text("$\(vm.currentPrice.formatted(.number.precision(.fractionLength(2))))")
			Text(vm.change > 0 ? "▲" : "▼")
				.foregroundStyle(vm.change > 0 ? .green : .red)
			List {
				ForEach(vm.priceHistory) { stockPrice in
					HStack {
						Text("주가: $\(stockPrice.price.formatted(.number.precision(.fractionLength(2))))")
						Spacer()
						Text(stockPrice.change > 0 ? "▲" : "▼")
							.foregroundStyle(stockPrice.change > 0 ? .green : .red)
						Text("\(stockPrice.change.formatted(.number.precision(.fractionLength(2))))")
					}
				}
			}
			
			if vm.isStreaming {
				ProgressView("로딩 중...")
			}
			
			Button(action: {
				Task {
					await vm.startStream()
				}
			}, label: {
				Text(vm.isStreaming ? "스트림 중..." : "시작")
					.frame(maxWidth: .infinity)
			})
			.disabled(vm.isStreaming)
			.buttonStyle(.borderedProminent)
			.padding(.horizontal)
		}
    }
}

#Preview {
    StockPriceView()
}
