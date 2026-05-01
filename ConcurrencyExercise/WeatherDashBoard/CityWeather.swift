//
//  CityWeather.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/1/26.
//

import Foundation


let cities = ["Seoul", "Tokyo", "NewYork", "London", "Paris"]

struct CityWeather: Identifiable {
	let id = UUID()
	let city: String
	var temperature: Int?
	var condition: String?
	var isLoading: Bool = true
	var errorMessage: String? = nil
}

struct WeatherResponse: Codable {
	let currentCondition: [CurrentCondition]
	
	enum CodingKeys: String, CodingKey {
		case currentCondition = "current_condition"
	}
}

struct CurrentCondition: Codable {
	let tempC: String
	let weatherDesc: [WeatherDesc]
	
	enum CodingKeys: String, CodingKey {
		case tempC = "temp_C"
		case weatherDesc
	}
}

struct WeatherDesc: Codable {
	let value: String
}

