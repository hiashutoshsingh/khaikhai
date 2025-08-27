import Foundation

class RestaurantListViewModel {
    enum State {
        case loading
        case success([Restaurant])
        case empty
        case error(String)
    }
    
    private let repository: RestaurantRepositoryProtocol
    var stateChanged: ((State) -> Void)?
    
    init(repository: RestaurantRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadRestaurants() {
        stateChanged?(.loading)
        Task {
            do {
                let restaurants = try await repository.fetchRestaurants()
                if restaurants.isEmpty {
                    stateChanged?(.empty)
                } else {
                    stateChanged?(.success(restaurants))
                }
            } catch {
                stateChanged?(.error(error.localizedDescription))
            }
        }
    }
}
