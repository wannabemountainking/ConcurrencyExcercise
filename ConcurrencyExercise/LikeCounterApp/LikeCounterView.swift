//
//  LikeCounterView.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/1/26.
//

import SwiftUI

struct LikeCounterView: View {
    
    @State private var vm: LikeCounterViewModel = .init()
    
    var body: some View {
        NavigationStack {
			ScrollView {
				VStack(spacing: 30) {
					
					Text("모든 게시물 '좋아요' 합산: \(vm.totalCount)")
						.font(.title)
					
					ForEach(vm.posts, id: \.id) { post in
						Color.gray.opacity(0.5).ignoresSafeArea()
							.overlay(alignment: .leading) {
								VStack(alignment: .leading, spacing: 10) {
									Text(post.title)
									Text("❤️ \(post.likeCount)")
									
									Button(post.isSending ? "⏳ 전송 중 ..." : "좋아요") {
										Task { await vm.like(postId: post.id) }
									}
									.buttonStyle(.plain)
									.frame(height: 40)
									.padding(.horizontal, 10)
									.foregroundStyle(.white)
									.background(post.isSending ? Color.gray : .green)
									.clipShape(RoundedRectangle(cornerRadius: 8))
									.disabled(post.isSending)
								}
								.padding(.horizontal, 20)
								.font(.title2)
								.fontWeight(.semibold)
							}
							.frame(height: 150)
							.clipShape(RoundedRectangle(cornerRadius: 10))
							.padding(.horizontal, 20)
					}
					
					HStack(spacing: 15) {
						Button("동시에 좋아요 폭격") {
							vm.bombardLikes()
						}
						.frame(maxWidth: .infinity)
						.frame(height: 45)
						.foregroundStyle(.white)
						.background(Color.indigo)
						.clipShape(RoundedRectangle(cornerRadius: 8))
						
						Button("초기화") {
							vm.reset()
						}
						.frame(maxWidth: .infinity)
						.frame(height: 45)
						.foregroundStyle(.white)
						.background(Color.orange)
						.clipShape(RoundedRectangle(cornerRadius: 8))
					} //:HSTACK
					.font(.title3)
					.fontWeight(.semibold)
					.padding(20)


				} //:VSTACK
			} //:SCROLL
            .navigationTitle("LikeCounter")
			.navigationBarTitleDisplayMode(.inline)
        } //:NAVSTACK
    }
}

#Preview {
    LikeCounterView()
}
