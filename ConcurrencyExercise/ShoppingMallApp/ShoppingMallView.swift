//
//  ShoppingMallView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/10/26.
//

import SwiftUI

struct ShoppingMallView: View {
	@State private var vm: ShoppingMallViewModel = .init()
	
    var body: some View {
		if vm.isLoading {
			ProgressView("로딩 중...")
		} else {
			VStack {
				List {
					ForEach(vm.priceResults, id: \.self) { priceResult in
						Text(priceResult)
					}
				}
				
				Text("총 합계: \(vm.totalPrice.decimalNumber)원")
				
				Button(action: {
					Task {
						await vm.fetchAllPrices()
					}
				}, label: {
					Text("가격 조회")
						.frame(maxWidth: .infinity)
				})
				.buttonStyle(.borderedProminent)
				.padding(.horizontal)
			}
		}
    }
}

#Preview {
    ShoppingMallView()
}
