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
                medicineHistorySection
                Spacer()
                buttonValidate
            }
            .padding()
            .overlay(alignment: .top) {
                listAisleSection
            }
            
        }
        .onAppear() {
            Task {
                await viewModel.fetchAisles()
            }
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
}

extension MedicineView {
    private var headerSection: some View {
        HStack {
            Text(viewModel.medicine.id != nil ? "New Medicine" : viewModel.medicine.name)
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
        ZStack(alignment: .top) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Aisle : \(viewModel.medicine.aisle?.name ?? "")")
                        .font(.title3)
                        .foregroundColor(Color(.black))

                    HStack {
                        TextField("", text: $viewModel.searchText,
                                  prompt: Text("Choose an aisle...")
                            .foregroundColor(.gray))
                        .font(.body)
                        .foregroundColor(Color("ColorFont"))
                        .autocorrectionDisabled()
                        Spacer()
                        if (!viewModel.searchText.isEmpty && !viewModel.aisleExist()) {
                            Button(action: {
                                Task {
                                    await viewModel.AddAisle()
                                }
                            }) {
                                Label("Add Aisle", systemImage: "plus.app")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                }
                .padding()
                .background(Color("BackgroundElement"))
                .cornerRadius(20)
                .accessibilityLabel("Aisle")
            }
            
        }
    }
    
    private var listAisleSection: some View {
        Group {
            if !viewModel.filteredAisles.isEmpty && !viewModel.searchText.isEmpty {
                GeometryReader { geo in
                    VStack(alignment: .leading, spacing: 4) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(viewModel.filteredAisles) { aisle in
                                    Button(action: {
                                        viewModel.medicine.aisle = aisle
                                        viewModel.searchText = ""
                                        viewModel.filteredAisles = []
                                    }) {
                                        Text(aisle.label)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                            .foregroundColor(Color(.black))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(.gray))
                                            .cornerRadius(4)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .frame(maxHeight: 155)
                        .background(Color("BackgroundElement"))
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                        .position(x: geo.size.width / 2, y: 440)
                    }
                }
                .zIndex(2)
            }
        }
        
    }
    
    private var medicineHistorySection: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("History")
                    .font(.title3)
                    .foregroundColor(Color("ColorFont"))
//                TextField("", text: $viewModel.searchText,
//                          prompt: Text("Choose an aisle...")
//                    .foregroundColor(.gray))
//                .font(.body)
//                .foregroundColor(Color("ColorFont"))
                
                
            }
            .padding()
            .background(Color("BackgroundElement"))
            .cornerRadius(20)
            .accessibilityLabel("Aisle")
            
        }
        
    }
    
    private var buttonValidate: some View {
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
}

#Preview {
    let viewModel = MedicineViewModel( session: FireBaseAuthService(), medicine: MedicineViewData.init())
    MedicineView(viewModel: viewModel)
    
}
