//
//  AutoTransforViewModel.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/3/26.
//

import Foundation
import Observation


/// AutoTransferViewModel의 역할: 개별 출금, 전체 동시 출금(이건 인위적임) 은행 자동이체 역할
@MainActor
@Observable
final class AutoTransforViewModel {
	
	let bankAccount: BankAccountActor = .shared
	
	private var balance: Int = 1_000_000 // 잔액
	private var transactions: [Transaction] = [] // 거래 내역
	var resultMessage: String = ""
	
	init() {
		Task {
			await fetchAccount()
		}
	}
	
	func fetchAccount() async {
		self.transactions = await bankAccount.getTransactions()
		do {
			self.balance = try await bankAccount.getBalance()
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func excuteOne(_ transfer: AutoTransfer) async {
		do {
			try await self.bankAccount.withdraw(title: "출금", amount: transfer.amount, description: transfer.name)
			self.resultMessage = "자동이체 완료 ✅ \(transfer.amount.decimalNumber)원 출금 (잔액: \(self.balance.decimalNumber)원)"
		} catch let error as BankError {
			if case let .insufficientFunds(balance, requested, description) = error {
				self.resultMessage = "요청액: \(requested.decimalNumber)원, 계좌 잔액: \(balance.decimalNumber)원 \(description)"
			}
		} catch {
			self.resultMessage = error.localizedDescription
		}
		await fetchAccount()
	}
	
	func excuteAll() async {
		await withTaskGroup(of: Void.self) { [weak self] group in
			guard let self else {return}
			group.addTask {
				for transfer in self.bankAccount.autoTransfers {
					await self.excuteOne(transfer)
				}
			}
		}
	}
}
