//
//  AisleListViewModel.swift
//  MediStock
//
//  Created by Bruno Evrard on 23/05/2025.
//

import Foundation

@MainActor
class AisleListViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var aisles: [AisleViewData] = []
    @Published var isError: Bool = false
    
    // MARK: - Public
    
    // MARK: - Private
    private let session: SessionManager
    private let dataStoreService: DataStore
    
    // MARK: - Init
    init(session: SessionManager) {
        self.session = session
        self.dataStoreService = session.storeService
    }
    
    // MARK: - Public methods
    func fetchAisles() async {
        do {
            let aislesData = try await dataStoreService.fetchAisles()
            self.aisles = aislesData.map(AisleMapper.mapToViewData)
        } catch {
            self.isError = true
        }
    }
    
}
