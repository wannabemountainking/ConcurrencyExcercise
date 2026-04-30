//
//  NewsFeedView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 4/30/26.
//

import SwiftUI

struct NewsFeedView: View {
	
//	@State private var vm: NewsViewModel = .init()
	@State private var vm: AsyncNewsFeedViewModel = .init()
	@State private var selectedTopic: NewsItem? = nil
	
    var body: some View {
		NavigationStack {
			if vm.isloading {
				ProgressView {
					Text("로딩 중...")
						.font(.headline)
						.foregroundStyle(.orange)
						.padding(.top, 12)
				}
				.progressViewStyle(.circular)
				.scaleEffect(2.5)
				.tint(.green)
			} else if let errorMsg = vm.errorMessage {
				Text(errorMsg)
					.font(.title)
				Button(action: {
					Task {
						await vm.asyncFetchNews()
					}
				}, label: {
					Text("다시 시도")
						.frame(maxWidth: .infinity)
				})
				.buttonStyle(.borderedProminent)
				.padding(.horizontal)
			} else {
				List {
					ForEach(vm.asyncNews, id: \.id) { newsItem in
						HStack {
							Text(newsItem.title)
								.font(.headline)
								.fontWeight(.light)
							Spacer()
							Text("출처: #: \(newsItem.userId)")
								.font(.caption)
								.foregroundStyle(.gray)
						}
						.onTapGesture {
							self.selectedTopic = newsItem
						}
					}
				}
				.navigationTitle("NewsFeed")
				.navigationBarTitleDisplayMode(.large)
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button(
							"",
							systemImage: "arrow.clockwise",
							action: {
								Task {
									await vm.asyncFetchNews()
								}
							}
						)
					}
				}
				.sheet(item: $selectedTopic) { topic in
					VStack(alignment: .leading, spacing: 20) {
						List {
							Text("Topic:")
								.font(.largeTitle)
							Text(topic.title)
								.font(.title3)
							Text("Reference:")
								.font(.title)
							Text("\(topic.userId)")
								.font(.title3)
							Text("Body: ")
								.font(.title2)
							Text(topic.body)
								.font(.headline)
						}
					}
				}
			}//:CONDITIONAL
				
		} //:NAVIGATION
		.task {
			await vm.asyncFetchNews()
		}
    }//:body
}

#Preview {
	NewsFeedView()
}
