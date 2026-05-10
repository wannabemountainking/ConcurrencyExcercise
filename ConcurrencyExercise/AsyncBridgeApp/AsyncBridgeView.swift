//
//  AsyncBridgeView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/10/26.
//

import SwiftUI

struct AsyncBridgeView: View {
	@State private var vm: AsyncBridgeViewModel = .init()
	
    var body: some View {
		if vm.isLoading {
			ProgressView("로딩 중...")
		} else {
			VStack(spacing: 20) {
				Text(vm.location)
				Text(vm.errorMessage)
				Button(action: {
					Task {
						await vm.fetchLocation()
					}
				}, label: {
					Text("위치 가져오기")
						.frame(maxWidth: .infinity)
				})
				.buttonStyle(.borderedProminent)
				.padding(.horizontal)
			}
		}
    }
}

#Preview {
    AsyncBridgeView()
}
