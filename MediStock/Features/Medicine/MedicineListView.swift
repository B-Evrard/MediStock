//
//  MedicineListView.swift
//  MediStock
//
//  Created by Bruno Evrard on 25/05/2025.
//

import SwiftUI

struct MedicineListView: View {
    
    @EnvironmentObject var session: SessionManager
    @StateObject var viewModel: MedicineListViewModel
    @State private var showMedicineView = false
    @State private var medicineToDelete: MedicineViewData?
    @State private var showDeleteAlert = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea(edges: .top)
                if (viewModel.isError) {
                    ErrorView(tryAgainVisible: true, onTryAgain: {
                        Task {
                            await viewModel.refreshMedicines()
                        }})
                } else  {
                    
                    VStack {
                        headerSection
                        if viewModel.isLoading {
                            Spacer()
                            ProgressViewLoading()
                            Spacer()
                        } else {
                            medicineList
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    viewModel.startListening()
                }
            }
        }
    }
}

extension MedicineListView {
    
    private var headerSection: some View {
        VStack {
            HStack {
                Text("Medicines")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                
                NavigationLink(destination: MedicineView(viewModel: MedicineViewModel(session: session, medicine: MedicineViewData.init(aisle: viewModel.aisleSelected ))))
                {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .frame(width: 20, height: 20)
                }
            }
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.callout)
                    .padding(.leading, 8)
                    .accessibilityHidden(true)
                TextField("Filter by name", text: $viewModel.search)
                    .font(.callout)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.leading, 10)
                
                Spacer()
                
                Picker("Sort by", selection: $viewModel.sortOption) {
                    Text("Name").tag(SortOption.name)
                    Text("Stock").tag(SortOption.stock)
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.sortOption) {
                    Task {
                        await viewModel.refreshMedicines()
                    }
                }
            }
            .background(Color("BackgroundElement"))
            .cornerRadius(20)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var medicineList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.medicines, id: \.id) { medicine in
                    NavigationLink(
                        destination: MedicineView(
                            viewModel: MedicineViewModel(
                                session: session,
                                medicine: medicine
                            )
                        )
                    ) {
                        VStack {
                            Text(medicine.name)
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Text("Stock : \(medicine.stock)")
                                .font(.body)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            //.padding(.leading, 20)
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color("BackgroundElement"))
                        .cornerRadius(20)
                        
                    }
                    .contextMenu {
                        if medicine.stock==0 {
                            Button(role: .destructive) {
                                medicineToDelete = medicine
                                showDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } 
                    }
                    
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color("BackgroundColor"))
                .listRowSeparator(.hidden)
            }
            .padding(.horizontal)
        }
        .refreshable {
            await viewModel.refreshMedicines()
        }
        .alert("Delete this medicine ?", isPresented: $showDeleteAlert, presenting: medicineToDelete) { medicine in
            Button("Delete", role: .destructive) {
                Task {
                    await _ = viewModel.deleteMedicine(medicine: medicine)
                    medicineToDelete = nil
                }
                
            }
            Button("Cancel", role: .cancel) {
                medicineToDelete = nil
            }
        } message: { medicine in
            Text("The medicine “\(medicine.name)” will be permanently deleted.")
        }
    }
}

#Preview {
    MedicineListView(viewModel: MedicineListViewModel(session: SessionManager()))
}
