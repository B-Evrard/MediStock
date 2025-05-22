import Foundation
import FirebaseFirestoreSwift

struct HistoryEntry: Codable {
    @DocumentID var id: String?
    var medicineId: String
    var userId: String
    var action: String
    var details: String
    var timestamp: Date

//    init(id: String? = nil, medicineId: String, user: String, action: String, details: String, timestamp: Date = Date()) {
//        self.id = id
//        self.medicineId = medicineId
//        self.user = user
//        self.action = action
//        self.details = details
//        self.timestamp = timestamp
//    }
}
