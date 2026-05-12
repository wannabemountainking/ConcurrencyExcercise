//
//  NewsView.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/12/26.
//

import SwiftUI

struct TopicView: View {
	@State private var vm: TopicViewModel = .init()
	
    var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				VStack(alignment: .leading, spacing: 20) {
					HStack {
						Text("연결 상태")
							.font(.title2)
							.fontWeight(.semibold)
						Spacer()
					}
					HStack {
						Text(vm.isLoading ? "🟢 연결됨" : "🔴 연결 안됨")
							.font(.title3)
							.fontWeight(.ultraLight)
						Spacer()
					}
				}
				.padding()
				.padding(.horizontal)
				
				ScrollView(.vertical) {
					ForEach(vm.newsHeadlines, id: \.id) { headline in
						let target = headline.translations
						VStack {
							//content
							HStack {
								Text("🇰🇷 : \(headline.original)")
									.font(.title3)
									.fontWeight(.heavy)
								Spacer()
							}
							.padding(.bottom, 8)
							
							if let englishIndex = target.firstIndex(where: { $0.name == "영어" }),
							   let chineseIndex = target.firstIndex(where: { $0.name == "중국어" }),
							   let japaneseIndex = target.firstIndex(where: { $0.name == "일본어" })
							{
								HStack {
									Text("🇺🇸: \(target[englishIndex].translated)")
									Spacer()
								}
								HStack {
									Text("🇨🇳: \(target[chineseIndex].translated)")
									Spacer()
								}
								HStack {
									Text("🇯🇵: \(target[japaneseIndex].translated)")
									Spacer()
								}
							}
						} //:VSTACK
						.padding(.bottom)
						
					} //:LOOP
				} //:SCROLL
				.scrollIndicators(.hidden)
				.padding()
				.padding(.horizontal)
				
				HStack(spacing: 20) {
					Button(action: {
						Task {
							await vm.connect()
						}
					}, label: {
						Text("연결")
							.frame(maxWidth: .infinity)
					})
					.buttonStyle(.borderedProminent)
					.disabled(vm.isLoading)
					
					Button(action: {
						vm.disconnect()
					}, label: {
						Text("연결 해제")
							.frame(maxWidth: .infinity)
					})
					.buttonStyle(.borderedProminent)
					.disabled(!vm.isLoading)
				}
				.padding()
				.padding(.horizontal)
				.padding(.bottom, 20)
				
			} //:VSTACK
			.navigationTitle("World Topics")
		} //:NAVSTACK
    }
}

#Preview {
    TopicView()
}
