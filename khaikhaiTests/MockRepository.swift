//
//  MockReposioty.swift
//  khaikhai
//
//  Created by Ashutosh Singh on 27/08/25.
//

import XCTest
@testable import khaikhai

final class MockRestaurantRepository: RestaurantRepositoryProtocol {
    
    var resultMenus: Result<[MenuItem], Error> = .success([])
    
    var resultRestraunts: Result<[Restaurant], Error> = .success([])
    
    func fetchRestaurants() async throws -> [Restaurant] {
        
        switch resultRestraunts {
        case .success(let restraunt):
            return restraunt
        case .failure(let error):
            throw error
        }
    }
    
    func fetchMenu(for restaurantId: String) async throws -> [MenuItem] {
        switch resultMenus {
        case .success(let menu):
            return menu
        case .failure(let error):
            throw error
        }
    }
}
