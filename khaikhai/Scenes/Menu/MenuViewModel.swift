import Foundation

final class MenuViewModel {
    enum State {
        case loading
        case success([MenuItem])
        case empty
        case error(String)
    }
    
    private let repository: RestaurantRepositoryProtocol
    var stateChanged: ((State) -> Void)?
    let restaurantId: String
    
    init(repository: RestaurantRepositoryProtocol, restaurantId: String) {
        self.repository = repository
        self.restaurantId = restaurantId
    }
    
    func loadMenu() {
        stateChanged?(.loading)
        Task {
            do {
                let menu = try await repository.fetchMenu(for: restaurantId)
                if menu.isEmpty {
                    stateChanged?(.empty)
                } else {
                    stateChanged?(.success(menu))
                }
            } catch {
                stateChanged?(.error(error.localizedDescription))
            }
        }
    }
}
