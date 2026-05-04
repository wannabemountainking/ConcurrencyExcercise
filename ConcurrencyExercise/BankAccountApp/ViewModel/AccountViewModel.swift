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
	
	func fetchAccount() async {
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
	
	func processDeposit(amount: Int, description: String) async {
		await self.bankAccount.deposit(title: "입금", amount: amount, description: description)
		await fetchAccount()
		self.resultMessage = "입금 완료 ✅ \(amount.decimalNumber)원 입금\n잔액: \(self.accountBalance.decimalNumber)원"
		print(await self.bankAccount.getTransactions())
	}
	
	func transfer(amount: Int, description: String) async {
		do {
			try await self.bankAccount.withdraw(title: "출금", amount: amount, description: description)
			self.resultMessage = "출금 완료 ✅ \(amount.decimalNumber)원 출금\n잔액: \(self.accountBalance.decimalNumber)원"
			print(description)
		} catch let err as BankError {
			if case let .insufficientFunds(balance, requested, description) = err {
				self.resultMessage = "\(description)\n요청액: \(requested.decimalNumber)원\n계좌 잔액: \(balance.decimalNumber)원"
			}
		} catch {
			self.resultMessage = error.localizedDescription
		}
		await fetchAccount()
	}
}
