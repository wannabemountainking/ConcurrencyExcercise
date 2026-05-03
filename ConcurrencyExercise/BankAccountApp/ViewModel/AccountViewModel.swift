//
//  AccountViewModel.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/3/26.
//

import Foundation
import Observation

/// AccountViewModel의 역할: 개좌 불러오기, 송금하기 등 은행 창구 역할
extension Int {
	var decimalNumber: String {
		self.formatted(.number.decimalSeparator(strategy: .always))
	}
}


@MainActor
@Observable
final class AccountViewModel {
	
	let bankAccount: BankAccountActor = .shared
	var accountBalance: Int = 1_000_000
	var accountTransactions: [Transaction] = []
	var resultMessage: String = ""
	
	init() {
		Task {
			await fetchAccount()
		}
	}
	
	private func fetchAccount() async {
		self.accountTransactions = await bankAccount.getTransactions()
		do {
			self.accountBalance = try await bankAccount.getBalance()
		} catch let err as BankError {
			if case .invalidAmount(let description) = err {
				self.resultMessage = description
			}
		} catch {
			self.resultMessage = error.localizedDescription
		}
	}
	
	func transfer(amount: Int, description: String) async {
		do {
			try await self.bankAccount.withdraw(amount: amount, description: description)
			await fetchAccount()
			self.resultMessage = "출금 완료 ✅ \(amount.decimalNumber)원 출금 (잔액: \(amount.decimalNumber)원)"
		} catch let err as BankError {
			if case let .insufficientFunds(balance, requested, description) = err {
				self.resultMessage = "요청액: \(requested.decimalNumber)원, 계좌 잔액: \(balance.decimalNumber)원 \(description)"
			}
		} catch {
			self.resultMessage = error.localizedDescription
		}
	}
}
