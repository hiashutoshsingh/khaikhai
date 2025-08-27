import Foundation

struct MenuItem: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let price: Double
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, price
        case imageUrl = "image_url"
    }
}

struct MenuResponse: Codable {
    let menu: [MenuItem]
}
