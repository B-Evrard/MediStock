//
//  FullHistoryView.swift
//  MediStock
//
//  Created by Bruno Evrard on 17/06/2025.
//

import SwiftUI

struct FullHistoryView: View {
    var history: [HistoryEntryViewData]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                   
                    Text("Full History")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    
                    ForEach(history, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.ligne1)
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(item.details)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color("BackgroundElement"))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.bottom)
            }
            .background(Color("Background").ignoresSafeArea())
        }
    }
}
