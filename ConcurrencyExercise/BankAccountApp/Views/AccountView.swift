//
//  AccountView.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/3/26.
//

import SwiftUI

struct AccountView: View {

    @Environment(AccountViewModel.self) var accountVM
    @Environment(AutoTransforViewModel.self) var autoTransferVM
	
    var body: some View {
        ScrollView {
			Section {
				//contentView
				VStack(spacing: 15) {
					HStack {
						Text("계좌 번호: \(BankAccountActor.accountNumber)")
							.font(.title)
							.fontWeight(.light)
						Spacer()
					}
					HStack {
						Text("잔액: \(accountVM.accountBalance)원")
							.font(.title)
							.fontWeight(.light)
						Spacer()
					}
				}
				.padding()
			} header: {
				HStack {
					Text("내 계좌")
						.font(.largeTitle)
						.fontWeight(.semibold)
						.foregroundStyle(.mint)
					Spacer()
				}
				.padding()
				.padding(.top, 10)
			}
			
			Divider()
			
			Section {
				//content
				ForEach(accountVM.accountTransactions, id: \.id) { transaction in
					HStack {
						Text(transaction.title)
							.padding(.trailing, 20)
						Text(transaction.description)
						Spacer()
						HStack {
							Text(transaction.title == "입금" ? "+" : "-")
							Text("\(transaction.amount)원")
						}
					}
					.font(.title2)
					.fontWeight(.light)
					.padding(.horizontal, 20)
				}
			} header: {
				HStack {
					Text("거래 내역")
						.font(.largeTitle)
						.fontWeight(.semibold)
						.foregroundStyle(.pink.opacity(0.7))
					Spacer()
				}
				.padding()
				.padding(.top, 10)
			}

        } //:SCROLL
		.background(Color.gray.opacity(0.2))
		.clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(20)
    }
}

#Preview {
	AccountView()
        .environment(AccountViewModel())
        .environment(AutoTransforViewModel())

}
