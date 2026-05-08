//
//  LoginView.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/8/26.
//

import SwiftUI

struct LoginView: View {
    @State private var vm: LoginViewModel = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            if vm.isLoading {
                ProgressView("로딩 중...")
            } else {
                Text(vm.userName.isEmpty ? "" : "이름: \(vm.userName)")
                Text(vm.theme.isEmpty ? "" : "화면모드: \(vm.theme)")
                Text(vm.adsMessage.isEmpty ? "" : "광고: \(vm.adsMessage)")
                Text(vm.errorMessage)
                Text(vm.elapsedTime)
            }
            
            Button(action: {
                Task {
                    await vm.initializeApp()
                }
            }, label: {
                Text("앱 초기화")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .font(.title2)
        .padding()
    }
}

#Preview {
    LoginView()
}
