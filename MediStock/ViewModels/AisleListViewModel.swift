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
    private var streamTask: Task<Void, Never>?
    
    private let aisleStreamingService: AisleStreamingService
    
    @Published var aisles: [AisleViewData] = []
    @Published var isError: Bool = false
    
    init(dataStoreService: DataStore = FireBaseStoreService()) {
        self.dataStoreService = dataStoreService
        self.aisleStreamingService = AisleStreamingService(dataStoreService: dataStoreService)
    }
    
    func startListening() {
        aisleStreamingService.startListening { [weak self] newAisles in
            DispatchQueue.main.async {
                self?.aisles = newAisles
            }
        }
    }
    
    func stopListening() {
        aisleStreamingService.stopListening()
    }
    
    
}
