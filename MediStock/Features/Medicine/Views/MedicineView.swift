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
    @Binding var path: NavigationPath
    
    @State private var showPicker = false
    @State private var showAddSheet = false
    @State private var newAisleName: String = ""
    @State private var isShowingFullHistory = false
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea(edges: .top)
            
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
                await viewModel.initMedicine()
            }
        }
        .alert(isPresented: $viewModel.isError) {
            if viewModel.isErrorInit {
                return Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK")) {
                        path.removeLast()
                    }
                )
            } else {
                return Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .sheet(isPresented: $isShowingFullHistory) {
            FullHistoryView(history: viewModel.medicine.history ?? [])
        }
        
    }
}

extension MedicineView {
    private var headerSection: some View {
        HStack {
            Text(viewModel.medicine.id == nil ? "New Medicine" : viewModel.medicine.name)
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
            
            InputFieldString(text: $viewModel.medicine.name, placeholder: "Medicine name")
        }
        .padding()
        .background(Color("BackgroundElement"))
        .cornerRadius(20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Medicine name \(viewModel.medicine.name)")
    }
    
    private var medicineStockSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stock")
                .font(.title3)
                .foregroundColor(Color("ColorFont"))
                .accessibilityHidden(true)
            
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
                .accessibilityHint("Tap to decrease stock")

                InputFieldInt(value: $viewModel.medicine.stock, placeholder: "0")
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
                    .accessibilityLabel("Medicine stock \(viewModel.medicine.stock)")
                
                Button(action: {
                    viewModel.medicine.stock += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .accessibilityHint("Tap to increase stock")
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
            VStack(alignment: .leading, spacing: 8) {
                Text("Aisle : \(viewModel.medicine.aisle?.name ?? "")")
                    .font(.title3)
                    .foregroundColor(Color(.black))
                    .accessibilityLabel("Aisle : \(viewModel.medicine.aisle?.name ?? "")")
                
                HStack {
                    InputFieldString(text: $viewModel.searchAisle, placeholder: "Choose an aisle...", autocorrectionDisabled: true)
                    Spacer()
                    if (!viewModel.searchAisle.isEmpty && !viewModel.aisleExist()) {
                        Button(action: {
                            Task {
                                await viewModel.addAisle()
                            }
                        }) {
                            Label("Add Aisle", systemImage: "plus.app")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .accessibilityHint("Tap for add aisle : \(viewModel.searchAisle)")
                    }
                }
                
            }
            .padding()
            .background(Color("BackgroundElement"))
            .cornerRadius(20)
        }
    }
    
    private var listAisleSection: some View {
        Group {
            if !viewModel.filteredAisles.isEmpty && !viewModel.searchAisle.isEmpty {
                GeometryReader { geo in
                    VStack(alignment: .leading, spacing: 4) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(viewModel.filteredAisles) { aisle in
                                    Button(action: {
                                        viewModel.medicine.aisle = aisle
                                        viewModel.searchAisle = ""
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
        VStack(alignment: .leading, spacing: 8) {
            Text("History")
                .font(.title3)
                .foregroundColor(Color("ColorFont"))
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 4) {
                    if let history = viewModel.medicine.history {
                        ForEach(history, id: \.id) { item in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.ligne1)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.black))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.details)
                                    .font(.caption2)
                                    .foregroundColor(Color(.black))
                                    .accessibilityLabel(item.detailsAccess)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(2)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            
                        }
                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity,maxHeight: 150)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color("BackgroundElement"))
        .cornerRadius(20)
        .onTapGesture {
            if let history = viewModel.medicine.history {
                isShowingFullHistory = history.count > 0 ? true : false
            }
           
        }
        .accessibilityLabel("History")
        .accessibilityHint("Tap to view the complete medication history")
        
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
    MedicineViewPreview()
}

struct MedicineViewPreview: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        let session = SessionManager()
        let viewModel = MedicineViewModel(session: session, medicine: MedicineViewData())
        
        return MedicineView(viewModel: viewModel, path: $path)
    }
}
