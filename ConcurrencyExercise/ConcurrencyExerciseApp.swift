//
//  ConcurrencyExerciseApp.swift
//  ConcurrencyExercise
//
//  Created by YoonieMac on 4/30/26.
//

import SwiftUI

@main
struct ConcurrencyExerciseApp: App {
	
	@State var accountVM: AccountViewModel = .init()
	@State var autoTransferVM: AutoTransforViewModel = .init()
	
    var body: some Scene {
        WindowGroup {
            BankMainView()
				.environment(accountVM)
				.environment(autoTransferVM)
        }
    }
}
