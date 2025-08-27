import Foundation

struct Restaurant: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let rating: Double
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, rating
        case imageUrl = "image_url"
    }
}

struct RestaurantResponse: Codable {
    let restaurants: [Restaurant]
}
