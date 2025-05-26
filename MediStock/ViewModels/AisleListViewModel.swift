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
    
    @Published var aisles: [AisleViewData] = []
    @Published var isError: Bool = false
    
    init(dataStoreService: DataStore = FireBaseStoreService()) {
        self.dataStoreService = dataStoreService
    }
    
    func startListening() {
        streamTask = Task {
            do {
                for try await batch in try dataStoreService.streamAisles() {
                    
                    let newAisles = batch.filter { newAisle in
                        !self.aisles.contains { $0.id == newAisle.id }
                    }
                    self.aisles.append(contentsOf: newAisles.map { AisleMapper.mapToViewData($0)})
                }
            } catch {
                print("Erreur de streaming: \(error)")
            }
        }
    }
    
    
}
