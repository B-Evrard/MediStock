import SwiftUI

struct AisleListView: View {
    @ObservedObject var viewModel: AisleListViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Binding var showMedicineView: Bool
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()

            ScrollView {
                ForEach(viewModel.aisles, id: \.self) { aisle in
                    HStack {
                        Text(aisle.label)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                    .background(Color("BackgroundElement"))
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                switch newPhase {
                case .active:
                    viewModel.startListening()
                    print("➡️ L’app est active")
                case .inactive:
                    viewModel.stopListening()
                    print("⏸ L’app est inactive")
                case .background:
                    print("🔙 L’app passe en arrière-plan")
                @unknown default:
                    break
                }
            }
        }
        .navigationTitle("Aisles")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showMedicineView = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .toolbarBackground(Color("Background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

//struct AisleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        AisleListView()
//    }
//}
