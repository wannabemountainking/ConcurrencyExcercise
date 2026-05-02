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
    case timeout(message: String)
    case duplicateCity(message: String)
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
	
	
	init(cityWeathers: [CityWeather] = [], isLoading: Bool = true, errorMessage: String? = nil, lastUpdated: Date? = nil) {
        initializingWhenButtonTapped()
		self.lastUpdated = lastUpdated
		Task {
			await fetchSequentially()
		}
	}
	
	func fetchWeather(for city: String) async throws -> CityWeather {
		
		guard let url = URL(string: "https://wttr.in/\(city)?format=j1") else {
			throw WeatherNetworkError.invalidURL(message: "URL 에러")
		}
        /// 타임아웃 구현
        var request = URLRequest(url: url)
        request.timeoutInterval = 1
        
        let (data, res) = try await URLSession.shared.data(for: request)
		guard let response = res as? HTTPURLResponse,
			  response.statusCode >= 200 && response.statusCode < 300 else {
			throw WeatherNetworkError.invalidResponse(message: "서버 응답 오류")
		}
		let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
		let temp = Int(decodedData.currentCondition[0].tempC) ?? 0
		let condition = decodedData.currentCondition[0].weatherDesc[0].value
		var cityWeather = CityWeather(city: city, temperature: temp, condition: condition)
		cityWeather.isLoading = false
		return cityWeather
	}
	
    func fetchSequentially() async {
        let start = Date()  // ← 없음
        initializingWhenButtonTapped()
		for city in cities {
            guard let index = self.cityWeathers.firstIndex(where: { $0.city == city }) else { continue }
            do {
                let cityWeather = try await fetchWeather(for: city)
                self.cityWeathers[index] = cityWeather
                self.cityWeathers[index].isLoading = false
                self.isLoading = false
            } catch let e as DecodingError {
                print("decodingError: \(e)")  // 이거 추가해서
                let cityWeather = CityWeather(city: city, isLoading: false, errorMessage: "응답 시간 초과")
                self.cityWeathers[index] = cityWeather
			} catch let error as WeatherNetworkError {
				switch error {
				case .invalidURL(let message): self.errorMessage = message
				case .invalidResponse(let message): self.errorMessage = message
                case .timeout(let message): self.errorMessage = message
                case .duplicateCity(let message): self.errorMessage = message
				}
			} catch {
                print("에러: \(city) - \(error)")  // 이것도
				self.errorMessage = "알 수 없는 에러"
			}
		}
		self.lastUpdated = Date()
        let elapsed = Date().timeIntervalSince(start)
        print("소요 시간: \(String(format: "%.2f", elapsed))초")  // ← 없음
	}
	
	func fetchConcurrently() async {
        let start = Date()  // ← 없음
        initializingWhenButtonTapped()
		await withTaskGroup(of: CityWeather.self) { [weak self] group in
			guard let self else { return }
			// 1. 모든 작업 동시에 시작
			for city in cities {
				group.addTask {
					do {
						return try await self.fetchWeather(for: city)
					} catch {
						return CityWeather(city: city, errorMessage: "날씨를 가져올 수 없습니다")
					}
				}
			}
			
			// 2. 완료되는 순서대로 수집
			for await cityWeather in group {
                guard let index = self.cityWeathers.firstIndex(where: { $0.city == cityWeather.city }) else { continue }
                self.cityWeathers[index] = cityWeather
                self.cityWeathers[index].isLoading = false
                self.isLoading = false
			}
		}
        self.lastUpdated = Date()
        let elapsed = Date().timeIntervalSince(start)
        print("소요 시간: \(String(format: "%.2f", elapsed))초")  // ← 없음
	}
    
    private func initializingWhenButtonTapped() {
        self.cityWeathers = cities.map { CityWeather(city: $0) }
        /// 중복 체크
        for city in cities {
            let duplcateIndices = self.cityWeathers.indices.filter { cityWeathers[$0].city == city }
            guard duplcateIndices.count == 1 else {
                // 중복 시 모든 해당 카드에 에러메시지 넣기
                duplcateIndices.forEach {
                    cityWeathers[$0].isLoading = false
                    cityWeathers[$0].errorMessage = "중복된 도시입니다"
                }
                continue
            }
        }
        self.isLoading = true
        self.errorMessage = nil
    }
}
