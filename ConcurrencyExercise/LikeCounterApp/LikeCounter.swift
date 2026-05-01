//
//  LikeCounter.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/1/26.
//

import Foundation


actor LikeCounter {
	
	/// [postId : likeCount]
	var counts: [Int: Int] = [:]
	
	func increment(postId: Int) {
		self.counts[postId, default: 1] += 1
	}
	
	func getCount(postId: Int) -> Int {
		return self.counts[postId, default: 1]
	}
	
	func totalCount() -> Int {
		return self.counts.reduce(0) { $0 + $1.value }
	}
}
