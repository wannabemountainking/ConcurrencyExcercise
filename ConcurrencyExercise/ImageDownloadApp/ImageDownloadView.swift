//
//  ImageDownloadView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/9/26.
//

import SwiftUI

struct ImageDownloadView: View {
    @State private var vm: ImageDownloadViewModel = .init()
    
    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView("로딩 중...")
            } else {
                List {
                    ForEach(vm.results, id: \.self) { urlString in
                        Text(urlString)
                    }
                }
                Text("소요시간: \(vm.elapedTime)")
            }
            Button(action: {
                Task {
                    await vm.downloadAll()
                }
            }, label: {
                Text("다운로드 시작")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ImageDownloadView()
}
