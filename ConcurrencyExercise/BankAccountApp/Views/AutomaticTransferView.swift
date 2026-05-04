//
//  AutomaticTransferView.swift
//  ConcurrencyExercise
//
//  Created by yoonie on 5/3/26.
//

import SwiftUI

struct AutomaticTransferView: View {
    
    @Environment(AutoTransforViewModel.self) var autoVM
    
    var body: some View {
        ScrollView {
            HStack {
                Text(TransactionType.autoTransfer.title)
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                Button("전체 출금") {
                    // Action
                    Task {
                        await autoVM.excuteAll()
                    }
                }
                .font(.title2)
                .fontWeight(.semibold)
                .padding(6)
                .padding(.horizontal, 20)
                .foregroundStyle(.white)
                .background(Color.blue.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 25))
            } //:HSTACK
            .padding(20)
            
            Divider()
            
            Section {
                ForEach(autoVM.autoTransfers, id: \.id) { auto in
                    VStack(spacing: 10) {
                        HStack {
                            Text(auto.name)
                            Spacer()
                            Text("\(auto.amount.decimalNumber)원")
                                .padding(.trailing, 7)
                            Button("출금") {
                                // Action
                                Task {
                                    await autoVM.excuteOne(auto)
                                }
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(6)
                            .padding(.horizontal, 10)
                            .foregroundStyle(.white)
                            .background(Color.blue.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        } //:HSTACK
                        
                        HStack {
                            Text(autoVM.resultMessage)
                            Spacer()
                        } //:HSTACK
                    } //:VSTACK
                    .font(.title2)
                    .padding(20)
                } //:LOOP
            }//:SECTION
        } //:SCROLL
        .padding(20)
        .task {
            await autoVM.fetchAccount()
        }
    }
}

#Preview {
    AutomaticTransferView()
        .environment(AutoTransforViewModel())
}
