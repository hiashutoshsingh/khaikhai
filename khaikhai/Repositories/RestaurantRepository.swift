import Foundation

protocol RestaurantRepositoryProtocol {
    func fetchRestaurants() async throws -> [Restaurant]
    func fetchMenu(for restaurantId: String) async throws -> [MenuItem]
}

class RestaurantRepository: RestaurantRepositoryProtocol {
    private let network: NetworkManaging
    
    init(network: NetworkManaging = NetworkManager()) {
        self.network = network
    }
    
    func fetchRestaurants() async throws -> [Restaurant] {
        let url = URL(string: "https://demo9798242.mockable.io/res")!
        let data = try await network.fetchData(from: url)
        let response = try JSONDecoder().decode(RestaurantResponse.self, from: data)
        return response.restaurants
    }
    
    func fetchMenu(for restaurantId: String) async throws -> [MenuItem] {
        //        let url = URL(string: "https://example.com/restaurant/\(restaurantId)/menu.json")!
        let url = URL(string: "https://demo9798242.mockable.io/menus")!
        let data = try await network.fetchData(from: url)
        let response = try JSONDecoder().decode(MenuResponse.self, from: data)
        return response.menu
    }
}
