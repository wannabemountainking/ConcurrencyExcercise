//
//  Transaction.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/3/26.
//

import Foundation


struct Transaction: Identifiable {
	let id = UUID()
    let date: Date
    let description: String
    let amount: Int       // 양수: 입금, 음수: 출금
    let balanceAfter: Int // 거래 후 잔액
}

struct AutoTransfer: Identifiable {
    let id = UUID()
    let name: String
    let amount: Int
}

enum BankError: Error {
	case insufficientFunds(balance: Int, requested: Int, description: String)
	case invalidAmount(description: String)
}
