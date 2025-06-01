//
//  MedicineView.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import SwiftUI

struct MedicineView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: MedicineViewModel
    
    @State private var showPicker = false
    @State private var showAddSheet = false
    @State private var newAisleName: String = ""
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                headerSection
                medicineNameSection
                medicineStockSection
                medicineAisleSection
                Spacer()
                Button(action: {
                    Task {
                        let isOk = await viewModel.validate()
                        if isOk {
                            dismiss()
                        }
                    }
                }) {
                    Text("Validate")
                        .foregroundColor(.white)
                        .font(.callout)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color(.red))
                        .cornerRadius(4)
                }
            }
            .padding()
            
        }
        .onAppear() {
            Task {
                await viewModel.fetchAisles()
            }
        }
        
    }
}

extension MedicineView {
    private var headerSection: some View {
        HStack {
            Text(viewModel.medicine.id.isEmpty ? "New Medicine" : viewModel.medicine.name)
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    private var medicineNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
                .font(.title3)
                .foregroundColor(Color("ColorFont"))
            TextField("", text: $viewModel.medicine.name,
                      prompt: Text("Medicine name")
                .foregroundColor(.gray))
            .font(.body)
            .foregroundColor(Color("ColorFont"))
            
        }
        .padding()
        .background(Color("BackgroundElement"))
        .cornerRadius(20)
        .accessibilityLabel("Medicine name")
    }
    
    private var medicineStockSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stock")
                .font(.title3)
                .foregroundColor(Color("ColorFont"))
            
            HStack {
                Button(action: {
                    if viewModel.medicine.stock > 0 {
                        viewModel.medicine.stock -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                
                TextField(
                    "",
                    value: $viewModel.medicine.stock,
                    formatter: NumberFormatter(),
                    prompt: Text("0")
                        .foregroundColor(.gray)
                )
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .font(.body)
                .foregroundColor(Color("ColorFont"))
                
                Button(action: {
                    viewModel.medicine.stock += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color("BackgroundElement"))
        .cornerRadius(20)
        .accessibilityLabel("Medicine stock")
    }
    
    private var medicineAisleSection: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Aisles")
                    .font(.title3)
                    .foregroundColor(Color("ColorFont"))
                TextField("", text: $viewModel.searchText,
                          prompt: Text("Choose an aisle...")
                    .foregroundColor(.gray))
                .font(.body)
                .foregroundColor(Color("ColorFont"))
                
                
            }
            .padding()
            .background(Color("BackgroundElement"))
            .cornerRadius(20)
            .accessibilityLabel("Aisle")
            
            if !viewModel.filteredAisles.isEmpty && viewModel.searchText != "" {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(viewModel.filteredAisles) { aisle in
                            Button(action: {
                                viewModel.medicine.aisle = aisle
                                viewModel.searchText = aisle.label
                                viewModel.filteredAisles = []
                            }) {
                                Text(aisle.label)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemBackground))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .frame(maxHeight: 150)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }

            if let selected = viewModel.medicine.aisle {
                Text("Selected: \(selected.label)")
                    .padding(.top)
            }
        }
        
    }
}

#Preview {
    let viewModel = MedicineViewModel( session: FireBaseAuthService(), medicine: MedicineViewData.init())
    MedicineView(viewModel: viewModel)
    
}
