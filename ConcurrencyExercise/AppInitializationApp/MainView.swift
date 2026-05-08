//
//  MainView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/8/26.
//

import SwiftUI

struct MainView: View {
	@State private var vm: InitViewModel = .init()
	
    var body: some View {
		
		VStack(spacing: 20) {
			if vm.isLoading || (vm.userName.isEmpty && vm.theme.isEmpty && vm.notificationCount == 0) {
				ProgressView("로딩 중...")
			} else {
				Text("이름: \(vm.userName)")
				Text("테마: \(vm.theme)")
				Text("알림: \(vm.notificationCount)회")
				Text("소요 시간: \(vm.elapsedTime)초")
			}//:CONDITIONAL

			Button(action: {
				Task {
					await vm.initializeTask()
				}
			}, label: {
				Text("앱 초기화(Task)")
					.frame(maxWidth: .infinity)
					
			})
			.buttonStyle(.borderedProminent)
			.padding(.horizontal)
			
			Button(action: {
				Task {
					await vm.initializeAsyncLet()
				}
			}, label: {
				Text("앱 초기화(Async Let)")
					.frame(maxWidth: .infinity)
			})
			.buttonStyle(.borderedProminent)
			.padding(.horizontal)

		} //:VSTACK
		.font(.title3)
		.padding()
    }
}

#Preview {
    MainView()
}
