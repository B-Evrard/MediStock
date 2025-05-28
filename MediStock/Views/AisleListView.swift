import SwiftUI

struct AisleListView: View {
    @ObservedObject var viewModel = AisleListViewModel()
    @EnvironmentObject var userManager: UserManager
    
    @State private var showMedicineView = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    ForEach(viewModel.aisles, id: \.self) { aisle in
                        //NavigationLink(destination: MedicineListView()) {
                        HStack {
                            Text(aisle.label)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
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
                .padding(.horizontal)
                .navigationBarTitle("Aisles")
                .toolbarBackground(Color("Background"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationBarItems(trailing:
                                        Button(action: {
                    showMedicineView = true
                }) {
                    Image(systemName: "plus")
                }
                )
            }
            .onAppear {
                viewModel.startListening()
            }
            .onDisappear {
                viewModel.stopListening()
            }
            .navigationDestination(isPresented: $showMedicineView) {
                MedicineView(viewModel: MedicineViewModel(userManager: userManager, medicine: MedicineViewData.init()))
            }
            
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView()
    }
}
