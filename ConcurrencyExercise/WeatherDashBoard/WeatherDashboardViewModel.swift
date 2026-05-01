//
//  WeatherDashboardViewModel.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/1/26.
//

import Foundation
import Observation


enum WeatherNetworkError: Error {
	case invalidURL(message: String)
	case invalidResponse(message: String)
}

@MainActor
@Observable
final class WeatherDashboardViewModel {
	
	var cityWeathers: [CityWeather] = []
	var isLoading: Bool = true
	var errorMessage: String? = nil
	var lastUpdated: Date? = nil
	
	var lastUpdatedString: String {
		let isOver24Hours = Date().timeIntervalSince(lastUpdated ?? Date()) > 60 * 60 * 24
		guard let last = lastUpdated else {return ""}
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		if isOver24Hours {
			formatter.dateFormat = "MM월 dd일"
			return formatter.string(from: last)
		} else {
			formatter.dateFormat = "a h시 mm분"
			return formatter.string(from: last)
		}
	}
	
	init() {
		Task {
			await fetchSequentially()
		}
	}
	
	func fetchWeather(for city: String) async throws -> CityWeather? {
		guard !cityWeathers.contains(where: { $0.city == city }) else {return nil}
		guard let url = URL(string: "https://wttr.in/\(city)?format=j1") else {
			throw WeatherNetworkError.invalidURL(message: "URL 에러")
		}
		let (data, res) = try await URLSession.shared.data(from: url)
		guard let response = res as? HTTPURLResponse,
			  response.statusCode >= 200 && response.statusCode < 300 else {
			throw WeatherNetworkError.invalidResponse(message: "서버 응답 오류")
		}
		try? await Task.sleep(for: .seconds(0.3))
		let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
		let temp = Int(decodedData.currentCondition[0].tempC) ?? 0
		let condition = decodedData.currentCondition[0].weatherDesc[0].value
		var cityWeather = CityWeather(city: city, temperature: temp, condition: condition)
		cityWeather.isLoading = false
		return cityWeather
	}
	
	func fetchSequentially() async {
		let start = Date()
		for city in cities {
			do {
				guard let cityWeather = try await fetchWeather(for: city) else {return}
				self.cityWeathers.append(cityWeather)
			} catch let error as WeatherNetworkError {
				switch error {
				case .invalidURL(let message): self.errorMessage = message
				case .invalidResponse(let message): self.errorMessage = message
				}
			} catch {
				self.errorMessage = "알 수 없는 에러"
			}
		}
		let elapsed = Date().timeIntervalSince(start)
		print("소요 시간: \(String(format: "%.2f", elapsed))초")
		self.lastUpdated = Date()
		self.isLoading = false
	}
	
	func fetchConcurrently() async {
		let start = Date()
		await withTaskGroup(of: CityWeather.self) { [weak self] group in
			guard let self else { return }
			// 1. 모든 작업 동시에 시작
			for city in cities {
				group.addTask {
					do {
						guard let result = try await self.fetchWeather(for: city) else {
							return CityWeather(city: city, errorMessage: "날씨를 가져올 수 없습니다")
						}
						return result
					} catch {
						return CityWeather(city: city, errorMessage: "날씨를 가져올 수 없습니다")
					}
				}
			}
			
			// 2. 완료되는 순서대로 수집
			for await cityWeather in group {
				if let index = self.cityWeathers.firstIndex(where: { $0.city == cityWeather.city }) {
					cityWeathers[index] = cityWeather
				}
			}
		}
		let elapsed = Date().timeIntervalSince(start)
		print("소요 시간: \(String(format: "%.2f", elapsed))초")
		self.isLoading = false
	}
}
