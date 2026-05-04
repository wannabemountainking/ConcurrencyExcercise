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
	static let accountNumber: String = "123-456-7890"
    
	private var balance: Int  // 잔액
	private var transactions: [Transaction] // 거래 내역
	
	private init() {
		self.balance = 1_000_000
		self.transactions = [
			Transaction(date: Date(), title: "입금", description: "상여금", amount: 1_000_000, balanceAfter: 1_000_000)
		]
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
	
	func deposit(title: TransactionType, amount: Int, description: String) async {
		self.balance += amount
        
        await updateTrasactions(title: title, amount: amount, description: description)
	}
	
	func withdraw(title: TransactionType, amount: Int, description: String) async throws {
		if self.balance >= amount {
            print(self.balance)
			self.balance -= amount
            print(self.balance)
			await updateTrasactions(title: title, amount: amount, description: description)
		} else {
			throw BankError.insufficientFunds(
				balance: self.balance,
				requested: amount,
				description: "잔액 부족 ❌"
			)
		}
	}
    
	private func updateTrasactions(title: TransactionType, amount: Int, description: String) async {
        let transaction = await Transaction(
            date: Date(),
            title: title.title,
            description: description,
            amount: amount,
            balanceAfter: self.balance
        )
        self.transactions.append(transaction)
    }
	
}
