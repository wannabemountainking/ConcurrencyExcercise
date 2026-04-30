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
            VStack(spacing: 20) {
                
                Text("모든 게시물 '좋아요' 합산: \(vm.totalCount)")
                    .font(.title)
                
                List {
                    ForEach(vm.posts, id: \.id) { post in
                        HStack {
                            Text(post.title)
                                .fontWeight(.semibold)
                            Text("❤️ \(post.likeCount)")
                            if post.isSending {
                                ProgressView()
                            } else {
                                Button("좋아요") { }
                                    .disabled(post.isSending)
                            }
                        }
                    }
                }
                
                HStack {
                    Button("동시에 좋아요 폭격") {
                        vm.bombardLikes()
                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                }
                
            } //:VSTACK
            .navigationTitle("LikeCounter")
        } //:NAVSTACK
    }
}

#Preview {
    LikeCounterView()
}
