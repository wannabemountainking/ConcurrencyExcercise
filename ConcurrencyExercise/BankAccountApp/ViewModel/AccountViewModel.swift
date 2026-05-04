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
		let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let result = formatter.string(from: NSNumber(integerLiteral: self)) else {return "오류"}
        return result
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
	
    func fetchAccount(title: TransactionType? = nil, amount: Int? = nil, description: String? = nil) async {
		self.accountTransactions = await bankAccount.getTransactions()
		do {
			self.accountBalance = try await bankAccount.getBalance()
            guard let title, let amount else { return }
            self.resultMessage = "\(title.title) 완료 ✅ \(amount.decimalNumber)원 \(title.title)\n잔액: \(self.accountBalance.decimalNumber)원"
		} catch let err as BankError {
			if case .invalidAmount(let description) = err {
				self.resultMessage = description
			}
		} catch {
			self.resultMessage = error.localizedDescription
		}
	}
	
    func processDeposit(title: TransactionType, amount: Int, description: String) async {
        await self.bankAccount.deposit(title: title, amount: amount, description: description)
        await fetchAccount(title: title, amount: amount, description: description)
	}
	
    func transfer(title: TransactionType, amount: Int, description: String) async {
		do {
			try await self.bankAccount.withdraw(title: title, amount: amount, description: description)
            await fetchAccount(title: title, amount: amount, description: description)
		} catch let err as BankError {
			if case let .insufficientFunds(balance, requested, description) = err {
				self.resultMessage = "\(description)\n요청액: \(requested.decimalNumber)원\n계좌 잔액: \(balance.decimalNumber)원"
			}
		} catch {
			self.resultMessage = error.localizedDescription
		}
	}
}
