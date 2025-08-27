//
//  AppFactory.swift
//  khaikhai
//
//  Created by Ashutosh Singh on 27/08/25.
//

struct AppFactory {
    private static let network = NetworkManager()
    private static let sharedRepository = RestaurantRepository(network: network)
    
    static func makeRestaurantListVC() -> ViewController {
        let vm = RestaurantListViewModel(repository: sharedRepository)
        let vc  = ViewController()
        vc.inject(viewModel: vm)
        return vc
    }

    static func makeMenuVC(for restaurant: Restaurant) -> MenuViewController {
        let vm = MenuViewModel(repository: sharedRepository, restaurantId: restaurant.id)
        return MenuViewController(viewModel: vm)
    }
}
