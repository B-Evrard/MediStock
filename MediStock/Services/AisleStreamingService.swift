//
//  AisleStreamingService.swift
//  MediStock
//
//  Created by Bruno Evrard on 28/05/2025.
//


class AisleStreamingService {
    private var streamTask: Task<Void, Never>?
    private let dataStoreService: DataStore

    init(dataStoreService: DataStore) {
        self.dataStoreService = dataStoreService
    }

    func startListening(onUpdate: @escaping ([AisleViewData]) -> Void) {
        streamTask?.cancel()
        streamTask = Task {
            do {
                for try await batch in try dataStoreService.streamAisles() {
                    let mappedAisles = batch.map { AisleMapper.mapToViewData($0) }
                    onUpdate(mappedAisles)
                }
            } catch {
                print("Erreur de streaming: \(error)")
            }
        }
    }

    func stopListening() {
        streamTask?.cancel()
        dataStoreService.detachAisleListener()
    }
}
