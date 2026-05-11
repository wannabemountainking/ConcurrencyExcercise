//
//  ChattingView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/11/26.
//

import SwiftUI

struct ChatView: View {
	@State private var vm: ChatViewModel = .init()
	
    var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				Group {
					Text(vm.isConnected ? "🟢 연결됨" : "🔴 연결 안됨")
					Text("메시지 수: \(vm.messages.count)통")
				}
				
				Group {
					ScrollView(.vertical) {
						ForEach(vm.messages, id: \.id) { message in
							VStack {
                                HStack {
                                    Text(message.sender)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                HStack {
                                    Text(message.content)
                                        .font(.headline)
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Text("수신 시각: \(message.receivedAt.timeOnly)")
                                        .font(.footnote)
                                }
								
							}
						}
						.scrollIndicators(.hidden)
					}
				}
				
				Group {
					HStack {
						Button(action: {
							Task {
								await vm.connect()
							}
						}, label: {
							Text("연결")
								.frame(maxWidth: .infinity)
						})
						.buttonStyle(.borderedProminent)
						.disabled(vm.isConnected)
						
						Button(action: {
							vm.disConnect()
						}, label: {
							Text("연결 해제")
								.frame(maxWidth: .infinity)
						})
						.buttonStyle(.borderedProminent)
						.disabled(!vm.isConnected)
					}
				}
			}
			.navigationTitle("Chatting")
			.padding(20)
			.padding(.bottom, 20)
		}
    }
}

#Preview {
    ChatView()
}
