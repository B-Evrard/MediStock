//
//  MedicineListView.swift
//  MediStock
//
//  Created by Bruno Evrard on 25/05/2025.
//

import SwiftUI

struct MedicineListView: View {
    
    @EnvironmentObject var session: FireBaseAuthService
    
    @StateObject var viewModel: MedicineListViewModel
    @State private var showMedicineView = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea(edges: .top)
                VStack {
                    headerSection
                    medicineList
                }
            }
            .onAppear {
                Task {
//                    if (viewModel.medicines.isEmpty) {
//                        await viewModel.fetchMedicines()
//                    }
                    viewModel.startListening()
                            
                }
            }
            
        }
    }
}

extension MedicineListView {
    
    private var headerSection: some View {
        HStack {
            Text("Medicines")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
            Spacer()
            
            NavigationLink(destination: MedicineView(viewModel: MedicineViewModel(session: session, medicine: MedicineViewData.init())))
            {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal)
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
                    .onAppear {
//                        if medicine == viewModel.medicines.last {
//                            Task {
//                                await viewModel.fetchMedicines()
//                            }
//                        }
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
        
       
    }
     
}

#Preview {
    MedicineListView(viewModel: MedicineListViewModel())
}
