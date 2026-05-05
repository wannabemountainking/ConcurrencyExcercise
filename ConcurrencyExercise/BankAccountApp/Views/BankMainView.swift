//
//  MainView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/3/26.
//

import SwiftUI

struct BankMainView: View {
	@Environment(AccountViewModel.self) var accountVM
	@Environment(AutoTransforViewModel.self) var autoTransferVM
	@State private var selectedTab: Int = 0
    
    var body: some View {
		TabView(selection: $selectedTab) {
            Tab("계좌", systemImage: "banknote", value: 0) {
                AccountView()            }
			
			Tab("입금", systemImage: "tray.and.arrow.down.fill", value: 1) {
				DepositView()
			}
			Tab("송금", systemImage: "arrow.right.arrow.left", value: 2) {
                TransactionView()
            }
            Tab("자동이체", systemImage: "repeat", value: 3) {
                AutomaticTransferView()
            }
        }
		.task {
			await self.accountVM.fetchAccount()
			await self.autoTransferVM.fetchAccount()
		}
		.onChange(of: selectedTab) { _, newValue in
			switch newValue {
			case 0:
				Task { await accountVM.fetchAccount() }
			case 1:
				accountVM.resultMessage = ""
			case 2:
				accountVM.resultMessage = ""
			case 3:
				Task { await autoTransferVM.fetchAccount() }
			default: return
			}
		}
    }
}

#Preview {
    BankMainView()
        .environment(AccountViewModel())
        .environment(AutoTransforViewModel())
}
