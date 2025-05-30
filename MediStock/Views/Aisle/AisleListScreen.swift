//
//  AisleListScreen.swift
//  MediStock
//
//  Created by Bruno Evrard on 30/05/2025.
//


import SwiftUI

struct AisleListScreen: View {
    @StateObject private var viewModel = AisleListViewModel()
    @EnvironmentObject var session: FireBaseAuthService
    
    @State private var showMedicineView = false
    
    var body: some View {
        NavigationStack {
            AisleListView(viewModel: viewModel, showMedicineView: $showMedicineView)
                .navigationDestination(isPresented: $showMedicineView) {
                    MedicineView(viewModel: MedicineViewModel(session: session, medicine: MedicineViewData()))
                }
        }
        
        
        
    }
}
