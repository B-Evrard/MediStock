import SwiftUI

struct AisleListView: View {
    
    @EnvironmentObject var session: SessionManager
    @StateObject var viewModel: AisleListViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea(edges: .top)
                if viewModel.isLoading {
                    Spacer()
                    ProgressViewLoading()
                    Spacer()
                } else {
                    if (viewModel.isError) {
                        ErrorView(tryAgainVisible: true, onTryAgain: {
                            Task {
                                await viewModel.fetchAisles()
                            }})
                    } else  {
                        VStack {
                            headerSection
                            aisleList
                        }
                    }
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
            .accessibilityLabel("Add medicine")
            .accessibilityHint("Tap to add medicine")
        }
        .padding(.horizontal)
    }
    
    private var aisleList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.aisles, id: \.self) { aisle in
                    NavigationLink(destination: MedicineListView(viewModel: MedicineListViewModel(session: session,aisleSelected: aisle))) {
                        HStack {
                            Text(aisle.label)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .padding(.vertical,20)
                        .padding(.horizontal)
                        .background(Color("BackgroundElement"))
                        .cornerRadius(20)
                        
                    }
                    .accessibilityHint("Tap for the list of medicines in \(aisle.label)")
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
        let session = SessionManager()
        let viewModel = AisleListViewModel(session: session)
    
        AisleListView(viewModel: viewModel)
    }
}
