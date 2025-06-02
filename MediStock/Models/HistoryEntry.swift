import Foundation
import FirebaseFirestore

struct HistoryEntry: Codable {
    @DocumentID var id: String?
    var medicineId: String
    var userId: String
    var action: String
    var details: String
    var timestamp: Date

    init(id: String? = nil, medicineId: String = "", userId: String = "", action: String = "", details: String = "", timestamp: Date = Date()) {
        self.id = id
        self.medicineId = medicineId
        self.userId = userId
        self.action = action
        self.details = details
        self.timestamp = timestamp
    }
}
