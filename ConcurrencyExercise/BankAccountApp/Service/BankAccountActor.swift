//
//  AutoTransferViewModel.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/3/26.
//

import Foundation


/// BankAccountActor의 기능: 잔액조회, 거래내역 조회, 입금, 출금
/// 주된 역할: 진짜 은행 계좌의 역할 수행
actor BankAccountActor {
	
	static let shared = BankAccountActor()
	
	let autoTransfers: [AutoTransfer] = [
		AutoTransfer(name: "월세", amount: 500_000),
		AutoTransfer(name: "넷플릭스", amount: 17_000),
		AutoTransfer(name: "헬스장", amount: 80_000),
		AutoTransfer(name: "보험료", amount: 120_000)
	]
	
	private var balance: Int  // 잔액
	private var transactions: [Transaction] // 거래 내역
	
	private init() {
		self.balance = 1_000_000
		self.transactions = []
	}
	
	func getBalance() throws -> Int {
		if self.balance >= 0 {
			return self.balance
		} else {
			throw BankError.invalidAmount(description: "잔고 표시 오류")
		}
	}
	
	func getTransactions() -> [Transaction] {
		 self.transactions
	}
	
	func deposit(amount: Int, description: String) {
		self.balance += amount
		var transaction = Transaction(
			date: Date(),
			description: description,
			amount: amount,
			balanceAfter: self.balance
		)
		self.transactions.append(transaction)
	}
	
	func withdraw(amount: Int, description: String) throws {
		if self.balance >= amount {
			self.balance -= amount
			var transaction = Transaction(
				date: Date(),
				description: description,
				amount: amount,
				balanceAfter: self.balance
			)
		} else {
			throw BankError.insufficientFunds(
				balance: self.balance,
				requested: amount,
				description: "잔액 부족 ❌"
			)
		}
	}
	
}
