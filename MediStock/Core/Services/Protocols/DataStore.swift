//
//  DataStore.swift
//  MediStock
//
//  Created by Bruno Evrard on 22/05/2025.
//


protocol DataStore {
    
    
// MARK: Aisles
    func fetchAisles() async throws -> [AisleModel]
    func addAisle(_ aisle: AisleModel) async throws -> AisleModel
    func getAisle(id: String) async throws -> AisleModel
    
    // MARK: Medicines
    func streamMedicines(aisleId: String?, filter: String?, sortOption: SortOption?) -> AsyncThrowingStream<MedicineUpdateModel, Error>
    func resetStreamMedicines()
    func getMedicine(id: String) async throws -> MedicineModel
    func medicineExistByNameAndAisle(name: String, aisleId: String) async throws -> Bool
    func addMedicine(_ medicine: MedicineModel) async throws -> MedicineModel
    func updateMedicine(_ medicine: MedicineModel) async throws
    func deleteMedicine(id: String) async throws
    
    // MARK: History
    func fetchHistory(medicineId: String) async throws -> [HistoryEntryModel]
    func addHistory(_ historyEntry: HistoryEntryModel) async throws -> HistoryEntryModel
    
}
