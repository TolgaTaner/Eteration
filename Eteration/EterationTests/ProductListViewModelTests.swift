//
//  ProductListViewModelTests.swift
//  EterationTests
//
//  Created by Tolga Taner on 18.07.2025.
//

import Testing
import Foundation
@testable import Eteration

struct ProductListViewModelTests {
    
    // MARK: - Mock ProductClient
    class MockProductClient: ProductClientProtocol {
        var shouldSucceed = true
        var mockProducts: [Product] = []
        var callCount = 0
        
        func get(path: String, queryItems: [URLQueryItem]?) async -> Result<[Product], APIError> {
            callCount += 1
            
            if shouldSucceed {
                return .success(mockProducts)
            } else {
                return .failure(.unhandledResponse)
            }
        }
    }
    
    // MARK: - Mock Delegate
    class MockDelegate: ProductListViewModelDelegate {
        var loadingStateChanges: [Bool] = []
        var productFetchedCallCount = 0
        var productNotFetchedCallCount = 0
        var lastError: Error?
        
        func loadingStateDidChange(_ isLoading: Bool) {
            loadingStateChanges.append(isLoading)
        }
        
        func productDidFetched() {
            productFetchedCallCount += 1
        }
        
        func productDidNotFetched(_ error: Error) {
            productNotFetchedCallCount += 1
            lastError = error
        }
    }
    
    // MARK: - Test Data
    static let mockProducts = [
        Product.init(createdAt: "1", name: "iPhone 15", image: "Apple", price: "A3092", description: "29999.99", model: "iphone15.jpg", brand: "Apple", id: "1")
    ]
    
    // MARK: - Test 1: Initialization
    @Test func testInitialization() {
        let viewModel = ProductListViewModel()
        
        #expect(viewModel.products.isEmpty)
        #expect(viewModel.filteredProducts.isEmpty)
        #expect(viewModel.allProducts.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.hasMoreData)
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.selectedBrand == nil)
        #expect(viewModel.selectedSortOption == .none)
    }
    
    // MARK: - Test 2: Search and Filtering
    @Test func testSearchAndFiltering() {
        let viewModel = ProductListViewModel()
        viewModel.products = Self.mockProducts
        
        // Test search by name
        viewModel.searchText = "iPhone"
        viewModel.filterProducts()
        
        #expect(viewModel.filteredProducts.count == 1)
        #expect(viewModel.filteredProducts.first?.name == "iPhone 15")
        
        // Test search by brand
        viewModel.searchText = "Apple"
        viewModel.filterProducts()
        
        #expect(viewModel.filteredProducts.count == 1)
        #expect(viewModel.filteredProducts.allSatisfy { $0.brand == "Apple" })
        
        // Test case insensitive search
        viewModel.searchText = "iphone"
        viewModel.filterProducts()
        
        #expect(viewModel.filteredProducts.count == 1)
        #expect(viewModel.filteredProducts.first?.name == "iPhone 15")
    }
    
    // MARK: - Test 3: Sorting
    @Test func testSorting() {
        let viewModel = ProductListViewModel()
        viewModel.products = Self.mockProducts
        viewModel.filterProducts()
        
        // Test sort by price low to high
        viewModel.selectedSortOption = .priceLowToHigh
        viewModel.sortProducts()
        
        let prices = viewModel.filteredProducts.compactMap { Double($0.price) }
        #expect(prices == prices.sorted())
        
        // Test sort by name A to Z
        viewModel.selectedSortOption = .nameAZ
        viewModel.sortProducts()
        
        let names = viewModel.filteredProducts.map { $0.name }
        #expect(names == names.sorted())
    }

} 
