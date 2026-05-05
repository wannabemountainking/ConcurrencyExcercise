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
	
	var balance: Int = 1_000_000 // 잔액
	var transactions: [Transaction] = [] // 거래 내역
    
    var autoTransfers: [AutoTransfer] = [
        AutoTransfer(name: "월세", amount: 500_000),
        AutoTransfer(name: "넷플릭스", amount: 17_000),
        AutoTransfer(name: "헬스장", amount: 80_000),
        AutoTransfer(name: "보험료", amount: 120_000)
    ]
	
	init() {
		Task {
			await fetchAccount()
		}
	}
	
    func fetchAccount(title: TransactionType? = nil, amount: Int? = nil, description: String? = nil) async {
		self.transactions = await bankAccount.getTransactions()
		do {
			self.balance = try await bankAccount.getBalance()
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func executeOne(_ transfer: AutoTransfer) async {
        guard let index = self.autoTransfers.firstIndex(where: { $0.id == transfer.id }) else { return }
		do {
            try await self.bankAccount.withdraw(title: .autoTransfer, amount: transfer.amount, description: transfer.name)
            await fetchAccount(title: .autoTransfer, amount: transfer.amount, description: transfer.name)
            self.autoTransfers[index].resultMessage = "\(TransactionType.autoTransfer.title) 완료 ✅\n\(transfer.amount.decimalNumber)원 \(TransactionType.autoTransfer.title)\n잔액: \(self.balance.decimalNumber)원"
		} catch let error as BankError {
			if case let .insufficientFunds(balance, requested, description) = error {
                self.autoTransfers[index].resultMessage = "요청액: \(requested.decimalNumber)원, 계좌 잔액: \(balance.decimalNumber)원 \(description)"
			}
		} catch {
            self.autoTransfers[index].resultMessage = error.localizedDescription
		}
	}
	
	func excuteAll() async {
		await withTaskGroup(of: Void.self) { [weak self] group in
			guard let self else {return}
			for transfer in self.autoTransfers {
				group.addTask {
					await self.executeOne(transfer)
				}
			}
		}
		await self.fetchAccount()
	}
}
