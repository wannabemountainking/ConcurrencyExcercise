//
//  Post.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/1/26.
//

import Foundation


struct Post: Identifiable {
    let id: Int
    let title: String
    var likeCount: Int = 0
    var isSending: Bool = false
}

let initialPosts: [Post] = [
    Post(id: 1, title: "Swift Concurrency 공부 중"),
    Post(id: 2, title: "오늘 점심 맛있었다"),
    Post(id: 3, title: "iOS 개발 재밌다")
]
