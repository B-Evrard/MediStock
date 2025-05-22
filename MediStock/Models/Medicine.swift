import Foundation
import FirebaseFirestoreSwift

struct Medicine: Codable {
    @DocumentID var id: String?
    var aisleId: String
    var name: String
    var stock: Int
    let nameSearch: String?

//    init(id: String? = nil, name: String, stock: Int, aisle: String) {
//        self.id = id
//        self.name = name
//        self.stock = stock
//        self.aisle = aisle
//        self.nameSearch = name.removingAccentsUppercased
//    }
//
//    static func == (lhs: Medicine, rhs: Medicine) -> Bool {
//        return lhs.id == rhs.id &&
//               lhs.name == rhs.name &&
//               lhs.stock == rhs.stock &&
//               lhs.aisle == rhs.aisle
//    }
}
