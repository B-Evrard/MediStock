//
//  ErrorView.swift
//  MediStock
//
//  Created by Bruno Evrard on 08/06/2025.
//

import SwiftUI

struct ErrorView: View {
    
    let tryAgainVisible: Bool
    let onTryAgain: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(20)
                .background(
                    Circle()
                        .fill(Color("BackgroundElement"))
                )
                .frame(width: 64, height: 64)
            
            Text("Error")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
            
            Text("An error has occured,")
                .font(.callout)
                .foregroundColor(.white)
            if (tryAgainVisible) {
                Text("please try again later")
                    .font(.callout)
                    .foregroundColor(.white)
            
                Button(action: onTryAgain) {
                Text("Try Again")
                    .foregroundColor(.white)
                    .font(.callout)
                    .bold(true)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(Color(.red))
                    .cornerRadius(4)
                }
            }
        }
        
    }
}

#Preview {
    ErrorView(tryAgainVisible: true, onTryAgain: {})
}
