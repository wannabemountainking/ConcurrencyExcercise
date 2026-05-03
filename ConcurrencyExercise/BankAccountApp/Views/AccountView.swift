//
//  AccountView.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/3/26.
//

import SwiftUI

struct AccountView: View {

    @Environment(AccountViewModel.self) var accountVM
    @Environment(AutoTransforViewModel.self) var autoTransferVM
	
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Section("내 계좌") {
                }
            }
        } //:SCROLL
        .padding(.horizontal, 20)
    }
}

#Preview {
	AccountView()
        .environment(AccountViewModel())
        .environment(AutoTransforViewModel())

}
