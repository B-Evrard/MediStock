import Foundation
import FirebaseFirestore

struct Medicine: Codable {
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

//    static func == (lhs: Medicine, rhs: Medicine) -> Bool {
//        return lhs.id == rhs.id &&
//               lhs.name == rhs.name &&
//               lhs.stock == rhs.stock &&
//               lhs.aisle == rhs.aisle
//    }
}
