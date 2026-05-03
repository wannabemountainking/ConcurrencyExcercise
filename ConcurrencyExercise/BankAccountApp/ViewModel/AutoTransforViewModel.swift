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
	
	init() {
		Task {
			await fetchAccount()
		}
	}
	
	private func fetchAccount() async {
		self.transactions = await bankAccount.getTransactions()
		do {
			self.balance = try await bankAccount.getBalance()
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func excuteOne(_ transfer: AutoTransfer) async {
		await self.bankAccount.deposit(
			amount: transfer.amount,
			description: transfer.name
		)
		await fetchAccount()
	}
	
	func excuteAll() async {
		await withTaskGroup(of: Void.self) { group in
			for transfer in self.bankAccount.autoTransfers {
				group.addTask {
					await self.excuteOne(transfer)
				}
			}
		}
		await fetchAccount()
	}
}
