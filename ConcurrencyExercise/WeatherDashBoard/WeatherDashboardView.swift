//
//  WeatherDashBoardView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/1/26.
//

import SwiftUI

struct WeatherDashboardView: View {
	
	@State private var vm: WeatherDashboardViewModel = .init()
	
    var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				VStack(alignment: .leading) {
					if vm.isLoading {
						Spacer()
						ProgressView {
							Text("날씨 불러오는 중 ...")
								.font(.headline)
								.foregroundStyle(.orange)
						}
						.progressViewStyle(.circular)
						.scaleEffect(2.0)
						.tint(.green)
						Spacer()
					} else if vm.errorMessage == nil {
						HStack {
							Text("🔹 마지막 업데이트: \(vm.lastUpdatedString)")
							Spacer()
						}
						.padding(.horizontal, 20)
					} else {
						HStack {
							Text(vm.errorMessage ?? "에러")
							Spacer()
							Button("다시 시도") {
								Task {
									await vm.fetchSequentially()
								}
							}
						}
						.padding(.horizontal, 20)
					}//:CONDITIONAL
				} //:VSTACK
				
				ScrollView {
					ForEach(vm.cityWeathers, id: \.id) { cityWeather in
						ZStack {
							Color.gray.opacity(0.3)
								.frame(maxWidth: .infinity)
							HStack {
								VStack(alignment: .leading, spacing: 5) {
									Text(cityWeather.city)
										.font(.title2)
										.fontWeight(.semibold)
									if cityWeather.isLoading {
										ProgressView {
											Label("불러오는 중...", systemImage: "circle")
										}
										.progressViewStyle(.circular)
									} else if let errMsg = cityWeather.errorMessage {
										Text(errMsg)
											.font(.title3)
											.fontWeight(.semibold)
											.foregroundStyle(.pink)
									} else {
										Text("🌡️ \(cityWeather.temperature ?? 0)℃")
											.font(.headline)
											.fontWeight(.medium)
										Text(cityWeather.condition ?? "")
											.font(.headline)
											.fontWeight(.light)
									}
									
								} //:VSTACK
								Spacer()
							} //:HSTACK
							.padding(15)
						} //:ZSTACK
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding(.horizontal, 20)
						
					} //:LOOP
				} //:SCROLL
				
				HStack {
					Button("순차적으로 가져오기") {
						Task {
							await vm.fetchSequentially()
						}
					}

					.foregroundStyle(.white)
					.frame(height: 40)
					.frame(maxWidth: .infinity)
					.padding(.horizontal, 20)
					.background(Color.blue)
					.clipShape(RoundedRectangle(cornerRadius: 10))
					
					Button("동시에 가져오기") {
						Task {
							await vm.fetchConcurrently()
						}
					}
					.font(.headline)
					.fontWeight(.semibold)
					.foregroundStyle(.white)
					.frame(height: 40)
					.frame(maxWidth: .infinity)
					.padding(.horizontal, 20)
					.background(Color.green.opacity(0.8))
					.clipShape(RoundedRectangle(cornerRadius: 10))
				}
				.font(.headline)
				.fontWeight(.semibold)
				.padding()
				.padding(.bottom, 20)
			} //:VSTACK
			.navigationTitle("날씨 대시보드")
			.navigationBarTitleDisplayMode(.inline)
		} //:NAVSTACK
    }
}

#Preview {
    WeatherDashboardView()
}
