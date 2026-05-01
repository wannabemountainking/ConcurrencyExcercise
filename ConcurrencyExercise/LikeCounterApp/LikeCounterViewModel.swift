//
//  LikeCounterViewModel.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/1/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class LikeCounterViewModel {
    
    var posts: [Post] = []
    var totalCount: Int {
        self.posts.reduce(0) { $0 + $1.likeCount }
    }
    
    init() {
        self.posts = initialPosts
    }
    
    func like(postId: Int) async {
        guard let index = self.posts.firstIndex(where: { $0.id == postId }) else {return}
        self.posts[index].isSending = true
        do {
            try await sendLikeToServer(postId: postId)
            self.posts[index].likeCount += 1
			print("postId: \(postId) → 현재 카운트: \(posts[index].likeCount)")
        } catch {
            print(error.localizedDescription)
        }
        self.posts[index].isSending = false
    }
    
    func bombardLikes() {
        for _ in 1...10 {
			Task.detached { [weak self] in
				guard let self else {return}
				await self.like(postId: 1)
			}
			Task.detached {[weak self] in
				guard let self else {return}
				await self.like(postId: 2)
			}
			Task.detached {[weak self] in
				guard let self else {return}
				await self.like(postId: 3)
			}
        }
    }
	
	func reset() {
		self.posts = initialPosts
	}
    
    private func sendLikeToServer(postId: Int) async throws {
		let delay = Int.random(in: 100...1000)
        try await Task.sleep(for: .milliseconds(delay))
    }
}

