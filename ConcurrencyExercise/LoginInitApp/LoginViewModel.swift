//
//  LoginViewModel.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/8/26.
//

import Foundation
import Observation


enum AppInitError: Error {
    case userFetchFailed
}

struct AppConfig {
    let theme: String
    static let defaultConfig = AppConfig(theme: "라이트모드")
}

@MainActor
@Observable
final class LoginViewModel {
    var userName: String = ""
    var theme: String = ""
    var adsMessage: String = ""
    var errorMessage: String = ""
    var isLoading: Bool = false
    var elapsedTime: String = ""
    
    init() {
        Task {
            await initializeApp()
        }
    }
    
    func initializeApp() async {
        let startTime = Date()
        self.isLoading = true
        async let user = fetchUserProfile()
        async let config = fetchAppConfig()
        async let ads = fetchAds()
        
        guard let u = try? await user else {
            self.errorMessage = "로그인이 필요합니다"
            self.userName = ""
            self.theme = ""
            self.adsMessage = ""
            self.isLoading = false
            return
        }
        self.userName = u
        self.theme = ((try? await config) ?? AppConfig.defaultConfig).theme
        self.adsMessage = (try? await ads) ?? ""
        self.isLoading = false
        self.elapsedTime = "\(Date().timeIntervalSince(startTime).formatted(.number.precision(.fractionLength(2))))초"
    }
    
    // 50% 확률로 실패
    private func fetchUserProfile() async throws -> String {
        try? await Task.sleep(for: .seconds(1))
        if Bool.random() {
            throw AppInitError.userFetchFailed
        }
        return "Jacob"
    }
    
    // 50% 확률로 실패 -> 기본값 사용
    private func fetchAppConfig() async throws -> AppConfig {
        try? await Task.sleep(for: .seconds(1))
        if Bool.random() { throw AppInitError.userFetchFailed }
        return AppConfig(theme: "다크모드")
    }
    
    // 50% 확률로 실패 -> 무시
    private func fetchAds() async throws -> String {
        try? await Task.sleep(for: .seconds(1))
        if Bool.random() { throw AppInitError.userFetchFailed }
        return "오늘의 광고: Swift 책 할인"
    }
}
