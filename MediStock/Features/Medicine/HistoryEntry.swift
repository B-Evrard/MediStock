import Foundation
import FirebaseFirestore

struct HistoryEntry: Codable {
    @DocumentID var id: String?
    var medicineId: String
    var action: String
    var details: String
    var modifiedAt: Date
    var modifiedByUserId: String
    var modifiedByUserName: String
    
    init(
        id: String? = nil,
        medicineId: String = "",
        action: String = "",
        details: String = "",
        modifiedAt: Date = Date(),
        modifiedByUserId: String = "",
        modifiedByUserName: String = ""
    ) {
        self.id = id
        self.medicineId = medicineId
        self.action = action
        self.details = details
        self.modifiedAt = modifiedAt
        self.modifiedByUserId = modifiedByUserId
        self.modifiedByUserName = modifiedByUserName
    }
    
}
