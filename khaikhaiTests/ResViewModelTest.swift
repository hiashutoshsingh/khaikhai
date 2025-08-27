//
//  ResViewModelTest.swift
//  khaikhai
//
//  Created by Ashutosh Singh on 27/08/25.
//

import XCTest
@testable import khaikhai

final class ResViewModelTests: XCTestCase {
    func testLoadMenuSuccess() {
        let mockRepository = MockRestaurantRepository()
        let menuItems = [Restaurant(id: "123", name: "Name", description: "Des", rating: 4.9, imageUrl: "www.google.com")]
        mockRepository.resultRestraunts = .success(menuItems)
        
        let viewModel = RestaurantListViewModel(repository: mockRepository)
        
        let loadingExpectation = expectation(description: "State is loading")
        let successExpectation = expectation(description: "State is success")
        
        var states: [RestaurantListViewModel.State] = []
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
        
        viewModel.loadRestaurants()
        
        wait(for: [loadingExpectation, successExpectation], timeout: 1)
        XCTAssertEqual(states.count, 2)
    }
    
    func testLoadMenuEmpty() {
        let mockRepository = MockRestaurantRepository()
        mockRepository.resultRestraunts = .success([])
        
        let viewModel = RestaurantListViewModel(repository: mockRepository)
        
        let loadingExpectation = expectation(description: "State is loading")
        let emptyExpectation = expectation(description: "State is empty")
        
        var states: [RestaurantListViewModel.State] = []
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
        
        viewModel.loadRestaurants()
        
        wait(for: [loadingExpectation, emptyExpectation], timeout: 1)
        XCTAssertEqual(states.count, 2)
    }
    
    func testLoadMenuError() {
        struct TestError: Error, LocalizedError {
            var errorDescription: String? { "Test error" }
        }
        let mockRepository = MockRestaurantRepository()
        mockRepository.resultRestraunts = .failure(TestError())
        
        let viewModel = RestaurantListViewModel(repository: mockRepository)
        
        let loadingExpectation = expectation(description: "State is loading")
        let errorExpectation = expectation(description: "State is error")
        
        var states: [RestaurantListViewModel.State] = []
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
        
        viewModel.loadRestaurants()
        
        wait(for: [loadingExpectation, errorExpectation], timeout: 1)
        XCTAssertEqual(states.count, 2)
    }
}
