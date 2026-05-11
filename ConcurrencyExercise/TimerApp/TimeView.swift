//
//  TimerView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/11/26.
//

import SwiftUI

struct TimeView: View {
	@State private var vm: TimerViewModel = .init()
	
    var body: some View {
		VStack {
			if vm.count != 0 {
				Text("카운트: \(vm.count)")
				Text("시간: \(vm.timestamp)")
			}
			if vm.isRunning {
				ProgressView("로드 중")
			}
			Button(action: {
				Task {
					await vm.startTimer()
				}
			}, label: {
				Text("시작")
					.frame(maxWidth: .infinity)
			})
			.buttonStyle(.borderedProminent)
			.padding(.horizontal)
			
			Button(action: {
				vm.stopTimer()
			}, label: {
				Text("정지")
					.frame(maxWidth: .infinity)
			})
			.buttonStyle(.borderedProminent)
			.padding(.horizontal)
		}
    }
}

#Preview {
    TimeView()
}
