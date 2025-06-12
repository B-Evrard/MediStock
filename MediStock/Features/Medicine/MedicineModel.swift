import Foundation
import FirebaseFirestore

struct MedicineModel: Codable {
    @DocumentID var id: String?
    var aisleId: String
    var name: String
    var stock: Int
    var nameSearch: String?

    init(id: String? = nil, aisleId: String = "", name: String = "", stock: Int = 0) {
        self.id = id
        self.aisleId = aisleId
        self.name = name
        self.stock = stock
        self.nameSearch = name.removingAccentsUppercased
    }

}
