//
//  NewsFeedView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 4/30/26.
//

import SwiftUI

struct NewsFeedView: View {
	
	@State var vm: NewsViewModel = .init()
	
    var body: some View {
		NavigationStack {
			if vm.isloading {
				ProgressView("로딩 중 ...")
					.font(.largeTitle)
			} else if vm.errorMessage != nil {
				Button(action: {
					vm.fetchNews()
				}, label: {
					Text("다시 시도")
						.frame(maxWidth: .infinity)
				})
				.buttonStyle(.borderedProminent)
				.padding(.horizontal)
			} else {
				List {
					ForEach(vm.news, id: \.id) { newsItem in
						HStack {
							Text(newsItem.title)
								.font(.title2)
								.fontWeight(.heavy)
							Spacer()
							Text("출처: #: \(newsItem.userId)")
								.font(.caption)
								.foregroundStyle(.gray)
						}
					}
				}
				.navigationTitle("NewsFeed")
				.navigationBarTitleDisplayMode(.inline)
			}
				
		} //:NAVIGATION
    }//:body
}

#Preview {
	NewsFeedView(vm: NewsViewModel())
}
