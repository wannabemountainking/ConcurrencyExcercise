//
//  FileDownloadView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/10/26.
//

import SwiftUI

struct FileDownloadView: View {
	@State private var vm: FileDownloadViewModel = .init()
	
    var body: some View {
		if vm.isLoading {
			ProgressView("로딩 중...")
		} else {
			VStack(spacing: 20) {
				Text(vm.result)
				Text(vm.errorMessage)
				Button(action: {
					Task {
						await vm.downloadFile(fileName: "SwiftConcurrency.pdf")
					}
				}, label: {
					Text("파일 다운로드")
						.frame(maxWidth: .infinity)
				})
				.buttonStyle(.borderedProminent)
				.padding(.horizontal)
			}
		}
    }
}

#Preview {
    FileDownloadView()
}
