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
	let title: String
    let description: String
    let amount: Int       // 양수: 입금, 음수: 출금
    let balanceAfter: Int // 거래 후 잔액
}

struct AutoTransfer: Identifiable {
    let id = UUID()
    let name: String
    let amount: Int
    var resultMessage: String = ""
}

enum BankError: Error {
	case insufficientFunds(balance: Int, requested: Int, description: String)
	case invalidAmount(description: String)
}

enum TransactionType {
    case deposit
    case withdraw
    case autoTransfer
    
    nonisolated var title: String {
        switch self {
        case .deposit: return "입금"
        case .withdraw: return "출금"
        case .autoTransfer: return "자동이체"
        }
    }
}
