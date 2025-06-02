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
                        .safeAreaPadding(.bottom)
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchAisles()
                }
            }
            
        }
    }
}

extension AisleListView {
    private var headerSection: some View {
        HStack {
            Text("Aisles")
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
    
    private var aisleList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.aisles, id: \.self) { aisle in
                    NavigationLink(destination: MedicineListView()) {
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
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color("BackgroundColor"))
                .listRowSeparator(.hidden)
            }
            .padding(.horizontal)
        }
        
       
    }
        
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView()
    }
}
