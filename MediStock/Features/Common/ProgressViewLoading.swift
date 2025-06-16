//
//  ProgressViewLoading.swift
//  MediStock
//
//  Created by Bruno Evrard on 08/06/2025.
//

import SwiftUI

struct ProgressViewLoading: View {
    @State private var isVisible = false
    var body: some View {
        
        ProgressView("Loading ....")
            .tint(.white)
            .foregroundColor(.white)
            .opacity(isVisible ? 1 : 0)
            .animation(.easeIn(duration: 0.5), value: isVisible)
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isVisible = true
                }
            }
            .accessibilityLabel("Loading")
            .accessibilityIdentifier("progressViewChargement")
    }
}

#Preview {
    ProgressViewLoading()
}
