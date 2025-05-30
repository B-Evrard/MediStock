import SwiftUI

struct AisleListView: View {
    @StateObject var viewModel = AisleListViewModel()
    @EnvironmentObject var session: FireBaseAuthService
    
    @State private var showMedicineView = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                VStack {
                    headerSection
                    aisleList
                }
                
                
            }
            .onAppear {
                Task {
                    await viewModel.fetchAisles()
                }
                
            }
            .fullScreenCover(isPresented: $showMedicineView) {
                MedicineView(viewModel: MedicineViewModel(session: session, medicine: MedicineViewData.init()))
            }
            
        }
    }
}

extension AisleListView {
    private var headerSection: some View {
        HStack {
            Text("Aisles")
                .foregroundColor(.white)
                .font(.title3)
                .bold()
            Spacer()
            Button(action: {
                showMedicineView = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
    
    private var aisleList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.aisles, id: \.self) { aisle in
                    //NavigationLink(destination: MedicineListView()) {
                    HStack {
                        Text(aisle.label)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        //.padding(.leading, 20)
                    }
                    .padding(.vertical,20)
                    .padding(.horizontal)
                    .background(Color("BackgroundElement"))
                    .cornerRadius(20)
                    //}
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color("BackgroundColor"))
                .listRowSeparator(.hidden)
            }
        }
        .padding(.horizontal)
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView()
    }
}
