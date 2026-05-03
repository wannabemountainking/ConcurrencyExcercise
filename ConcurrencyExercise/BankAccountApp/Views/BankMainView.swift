//
//  MainView.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 5/3/26.
//

import SwiftUI

struct BankMainView: View {
//    @Environment(AccountViewModel.self) var accountVM
//    @Environment(AutoTransforViewModel.self) var autoTransferVM
    
    var body: some View {
        TabView {
            Tab("계좌", systemImage: "banknote") {
                AccountView()
            }
            Tab("송금", systemImage: "arrow.right.arrow.left") {
                TransactionView()
            }
            Tab("자동이체", systemImage: "repeat") {
                AutomaticTransferView()
            }
        }
    }
}

#Preview {
    BankMainView()
        .environment(AccountViewModel())
        .environment(AutoTransforViewModel())
}
