//
//  TransmissionView.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/3/26.
//

import SwiftUI

struct TransactionView: View {
	
	@Environment(AccountViewModel.self) var accountVM
	@State private var withdrawDesc: String = ""
	@State private var withdrawAmount: String = ""
	
    var body: some View {
		ScrollView {
			Section {
				// content
				VStack {
					HStack {
						Text("출금 내용")
							.font(.title)
						Spacer()
					}
					.padding(.horizontal, 20)
					
					TextField("예: 식료품 등", text: $withdrawDesc)
						.font(.title2)
						.padding(8)
						.background(Color.gray.opacity(0.2))
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding(.horizontal, 20)
				}
				.padding(.bottom, 20)
				
				VStack {
					HStack {
						Text("금액 (원)")
							.font(.title)
						Spacer()
					}
					.padding(.horizontal, 20)
					
					TextField("숫자만 입력해 주세요", text: $withdrawAmount)
						.font(.title2)
						.padding(8)
						.background(Color.gray.opacity(0.2))
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding(.horizontal, 20)
				}
				.padding(.bottom, 20)
				
				Button(action: {
					guard let withdrawMoney = Int(self.withdrawAmount) else {
						self.withdrawAmount = ""
						return
					}
					Task {
                        await self.accountVM.transfer(title: .withdraw, amount: withdrawMoney, description: self.withdrawDesc)
                        self.withdrawDesc = ""
                        self.withdrawAmount = ""
					}
				}, label: {
					Text("출금하기")
						.font(.title)
						.fontWeight(.semibold)
						.kerning(2.0)
						.padding(.vertical, 5)
						.frame(maxWidth: .infinity)
				})
				.buttonStyle(.borderedProminent)
				.padding()
			} header: {
				HStack {
					Text("출금")
						.font(.largeTitle)
						.fontWeight(.semibold)
						.foregroundStyle(.mint)
					Spacer()
				}
				.padding()
				.padding(.vertical, 20)
				
			} footer: {
				HStack {
					Text(accountVM.resultMessage)
						.font(.title3)
					Spacer()
				}
				.padding(20)
			}

		}
		.padding(20)
        .task {
            accountVM.resultMessage = ""
        }
    }
}

#Preview {
    TransactionView()
		.environment(AccountViewModel())
}
