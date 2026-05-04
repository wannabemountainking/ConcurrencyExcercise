//
//  DepositView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/4/26.
//

import SwiftUI

struct DepositView: View {
	@Environment(AccountViewModel.self) var accountVM
	@State private var depositDesc: String = ""
	@State private var depositAmount: String = ""
	
    var body: some View {
		ScrollView {
			Section {
				// content
				VStack {
					HStack {
						Text("입금 내용")
							.font(.title)
						Spacer()
					}
					.padding(.horizontal, 20)
					
					TextField("예: 월급, 세금환급 등", text: $depositDesc)
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
					
					TextField("숫자만 입력해 주세요", text: $depositAmount)
						.font(.title2)
						.padding(8)
						.background(Color.gray.opacity(0.2))
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding(.horizontal, 20)
				}
				.padding(.bottom, 20)
				
				Button(action: {
                    
					guard let depositMoney = Int(depositAmount) else {
						self.depositAmount = ""
						return
					}
					Task {
                        await self.accountVM.processDeposit(title: .deposit, amount: depositMoney, description: self.depositDesc)
                        self.depositDesc = ""
                        self.depositAmount = ""
					}
				}, label: {
					Text("입금하기")
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
					Text("입금")
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
    DepositView()
		.environment(AccountViewModel())
}
