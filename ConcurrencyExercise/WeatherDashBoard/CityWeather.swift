//
//  CityWeather.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/1/26.
//

import Foundation


let cities = [
    "Seoul", "Tokyo", "NewYork", "London", "Paris",
    "Sydney", "Dubai", "Singapore", "Berlin", "Toronto",
    "Bangkok", "Mumbai", "Cairo", "Moscow", "Madrid",
    "Rome", "Amsterdam", "Vienna", "Prague", "Budapest",
    "Warsaw", "Stockholm", "Oslo", "Copenhagen", "Helsinki",
    "Athens", "Lisbon", "Brussels", "Zurich", "Geneva",
    "Barcelona", "Milan", "Naples", "Munich", "Frankfurt",
    "Hamburg", "Dublin", "Edinburgh", "Manchester", "Lyon",
    "Marseille", "Bordeaux", "Toulouse", "Strasbourg", "Nice",
    "Istanbul", "Ankara", "Tehran", "Baghdad", "Riyadh",
    "Doha", "Kuwait", "Muscat", "Karachi", "Lahore",
    "Delhi", "Kolkata", "Chennai", "Bangalore", "Hyderabad",
    "Dhaka", "Colombo", "Kathmandu", "Islamabad", "Kabul",
    "Tashkent", "Almaty", "Baku", "Tbilisi", "Yerevan",
    "Beijing", "Shanghai", "Guangzhou", "Chengdu", "Wuhan",
    "HongKong", "Taipei", "Osaka", "Nagoya", "Sapporo",
    "Manila", "Jakarta", "KualaLumpur", "Hanoi", "HoChiMinhCity",
    "Yangon", "Phnom Penh", "Vientiane", "Colombo", "Male",
    "Melbourne", "Brisbane", "Perth", "Auckland", "Wellington"
]

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

