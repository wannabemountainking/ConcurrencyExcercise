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
        
    }
}

#Preview {
	AccountView()
		.environment(AccountViewModel())
		.environment(AutoTransforViewModel())
}
