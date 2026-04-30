//
//  News.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 4/30/26.
//

import Foundation


struct NewsItem: Identifiable, Codable {
	let id: Int
	let title: String
	let body: String
	let userId: Int
}
