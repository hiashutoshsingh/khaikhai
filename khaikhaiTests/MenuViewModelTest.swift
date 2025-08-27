//
//  MenuViewModelTest.swift
//  khaikhai
//
//  Created by Ashutosh Singh on 27/08/25.
//

import XCTest
@testable import khaikhai

final class MenuViewModelTests: XCTestCase {
    func testLoadMenuSuccess() {
        let mockRepository = MockRestaurantRepository()
        let menuItems = [MenuItem(id: "1", name: "Pizza", price: 10.0, imageUrl: "String")]
        mockRepository.resultMenus = .success(menuItems)
        
        let viewModel = MenuViewModel(repository: mockRepository, restaurantId: "123")
        
        let loadingExpectation = expectation(description: "State is loading")
        let successExpectation = expectation(description: "State is success")
        
        var states: [MenuViewModel.State] = []
        viewModel.stateChanged = { state in
            states.append(state)
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .success(let menu):
                XCTAssertEqual(menu, menuItems)
                successExpectation.fulfill()
            default:
                break
            }
        }
        
        viewModel.loadMenu()
        
        wait(for: [loadingExpectation, successExpectation], timeout: 1)
        XCTAssertEqual(states.count, 2)
    }
    
    func testLoadMenuEmpty() {
        let mockRepository = MockRestaurantRepository()
        mockRepository.resultMenus = .success([])
        
        let viewModel = MenuViewModel(repository: mockRepository, restaurantId: "123")
        
        let loadingExpectation = expectation(description: "State is loading")
        let emptyExpectation = expectation(description: "State is empty")
        
        var states: [MenuViewModel.State] = []
        viewModel.stateChanged = { state in
            states.append(state)
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .empty:
                emptyExpectation.fulfill()
            default:
                break
            }
        }
        
        viewModel.loadMenu()
        
        wait(for: [loadingExpectation, emptyExpectation], timeout: 1)
        XCTAssertEqual(states.count, 2)
    }
    
    func testLoadMenuError() {
        struct TestError: Error, LocalizedError {
            var errorDescription: String? { "Test error" }
        }
        let mockRepository = MockRestaurantRepository()
        mockRepository.resultMenus = .failure(TestError())
        
        let viewModel = MenuViewModel(repository: mockRepository, restaurantId: "123")
        
        let loadingExpectation = expectation(description: "State is loading")
        let errorExpectation = expectation(description: "State is error")
        
        var states: [MenuViewModel.State] = []
        viewModel.stateChanged = { state in
            states.append(state)
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .error(let message):
                XCTAssertEqual(message, "Test error")
                errorExpectation.fulfill()
            default:
                break
            }
        }
        
        viewModel.loadMenu()
        
        wait(for: [loadingExpectation, errorExpectation], timeout: 1)
        XCTAssertEqual(states.count, 2)
    }
}
