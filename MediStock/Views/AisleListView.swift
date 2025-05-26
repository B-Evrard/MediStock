import SwiftUI

struct AisleListView: View {
    @ObservedObject var viewModel = MedicineStockViewModel()

    var body: some View {

        NavigationStack {
                ZStack {
                    Color("Background").ignoresSafeArea()
                    VStack {
                        Text("Aisles")
                            .font(.title)
                            .foregroundColor(.white)
                    Spacer()
                    }
                    
//                List {
//                    ForEach(viewModel.aisles, id: \.self) { aisle in
//                        NavigationLink(destination: MedicineListView()) {
//                            Text(aisle)
//                        }
//                    }
//                }
//                .navigationBarTitle("Aisles")
//                .toolbarBackground(Color.blue, for: .navigationBar)
//                .toolbarBackground(.visible, for: .navigationBar)
                
                //            .navigationBarItems(trailing: Button(action: {
                //                viewModel.addRandomMedicine(user: "test_user") // Remplacez par l'utilisateur actuel
                //            }) {
                //                Image(systemName: "plus")
                //            })
            }
            .onAppear {
                //viewModel.fetchAisles()
            }
            
            
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView()
    }
}
