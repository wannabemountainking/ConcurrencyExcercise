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
