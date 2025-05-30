//
//  MedicineView.swift
//  MediStock
//
//  Created by Bruno Evrard on 27/05/2025.
//

import SwiftUI

struct MedicineView: View {
    @StateObject var viewModel: MedicineViewModel
    
    @State private var showPicker = false
    @State private var showAddSheet = false
    @State private var newAisleName: String = ""
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                
                medicineNameSection
                medicineStockSection
                medicineAisleSection
            }
            .padding()
            
        }
        .onAppear {
            viewModel.startAisleStreamingListening()
        }
        .onDisappear {
            viewModel.stopAisleStreamingListening()
        }
    }
}

extension MedicineView {
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
                        .foregroundColor(.accentColor)
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
                        .foregroundColor(.accentColor)
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
        VStack(alignment: .leading, spacing: 8) {
            Text("Aisle")
                .font(.title3)
                .foregroundColor(Color("ColorFont"))
            
            Button(action: { showPicker = true }) {
                HStack {
                    Text(viewModel.medicine.aisle?.label ?? "Select an aisle")
                        .foregroundColor(viewModel.medicine.aisle == nil ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.accentColor)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
            
            .sheet(isPresented: $showPicker) {
                NavigationView {
                    List {
                        ForEach(viewModel.aisles, id: \.self) { aisle in
                            Button {
                                viewModel.medicine.aisle = aisle
                                showPicker = false
                            } label: {
                                HStack {
                                    Text(aisle.label)
                                    if viewModel.medicine.aisleId == aisle.id {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                        Button {
                            showAddSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add ailse…")
                            }
                        }
                    }
                    .navigationTitle("Select an aisle")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showPicker = false }
                        }
                    }
                }
            }
            
            .fullScreenCover(isPresented: $showAddSheet) {
                VStack(spacing: 20) {
                    Text("New Aisle")
                        .font(.headline)
                    TextField("Name", text: $newAisleName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Add") {
                        let trimmed = newAisleName.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        
                        // TODO: Ajout en base
                        newAisleName = ""
                        showAddSheet = false
                        showPicker = false
                    }
                    .disabled(newAisleName.trimmingCharacters(in: .whitespaces).isEmpty)
                    Button("Annuler") {
                        showAddSheet = false
                    }
                }
                .padding()
            }
        }
        
        .padding()
        .background(Color("BackgroundElement"))
        .cornerRadius(20)
        .accessibilityLabel("Allée du médicament")
    }
}

#Preview {
    let viewModel = MedicineViewModel( session: FireBaseAuthService(), medicine: MedicineViewData.init())
    MedicineView(viewModel: viewModel)
    
}
