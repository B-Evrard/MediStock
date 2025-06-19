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
    
    @State var isFromTab: Bool = false
    @Binding var path: NavigationPath
    
    
    var body: some View {
        
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
        .onDisappear() {
            Task {
                if (path.count == 0 && !isFromTab) {
                    viewModel.removeListener()
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
                
                NavigationLink(value: AppRoute.medicineCreate(forAisle: viewModel.aisleSelected)) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .frame(width: 20, height: 20)
                }
                .accessibilityLabel("Add medicine")
                .accessibilityHint("Tap to add medicine")
            }
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.leading, 8)
                    .accessibilityHidden(true)
                TextField(
                    text: $viewModel.search,
                    prompt: Text("Filter by name").foregroundStyle(.gray)
                ) {
                    EmptyView()
                }
                .font(.callout)
                .foregroundColor(.black) 
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
                    NavigationLink(value: AppRoute.medicineEdit(medicine)) {
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
                    .accessibilityHint("Tap for more details \(medicine.isDeleteable ? "Long press to delete" : "")")
                    
                    .contextMenu {
                        if medicine.isDeleteable {
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

//#Preview {
//    MedicineListViewPreview()
//}
//
//struct MedicineListViewPreview: View {
//    @State private var path = NavigationPath()
//
//    var body: some View {
//        let session = SessionManager()
//        let viewModel = Mei(session: session)
//
//        return MedicineListView(viewModel: viewModel, path: $path)
//    }
//}
