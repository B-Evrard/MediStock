//
//  AisleListViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/05/2025.
//

import Foundation

@MainActor
final class AisleListViewModel: ObservableObject {
    
    private let dataStoreService: DataStore
    
    @Published var aisles: [AisleViewData] = []
    @Published var isError: Bool = false
    
    init(dataStoreService: DataStore = FireBaseStoreService()) {
        self.dataStoreService = dataStoreService
    }
    
    func fetchAisles() async {
        do {
            let aislesData = try await dataStoreService.fetchAisles()
            self.aisles = aislesData.map(AisleMapper.mapToViewData)
            
        } catch {
            self.isError = true
        }
    }
    
    
}
