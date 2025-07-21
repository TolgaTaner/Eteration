//
//  ProductListViewModel.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

protocol ProductListViewModelDelegate: AnyObject {
    func loadingStateDidChange(_ isLoading: Bool)
    func productDidFetched()
    func productDidNotFetched(_ error: Error)
}

final class ProductListViewModel {
    
    weak var delegate: ProductListViewModelDelegate?
    
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var allProducts: [Product] = []
    
    var isLoading: Bool = false {
        didSet {
            delegate?.loadingStateDidChange(isLoading)
        }
    }
    
    var hasMoreData: Bool = true
    private var currentPage: Int = 0
    private let itemsPerPage: Int = 8
    
    // MARK: - Search Debouncing
    private var searchDebounceTimer: Timer?
    private let searchDebounceDelay: TimeInterval = 0.5
    
    private var _searchText: String = ""
    var searchText: String {
        get { return _searchText }
        set {
            _searchText = newValue
            filterProducts()
        }
    }
    
    var selectedBrand: String? = nil {
        didSet {
            filterProducts()
        }
    }
    
    var selectedSortOption: SortOption = .none {
        didSet {
            sortProducts()
        }
    }
    
    enum SortOption: String, CaseIterable {
        case none = "Default"
        case priceLowToHigh = "Price: Low to High"
        case priceHighToLow = "Price: High to Low"
        case nameAZ = "Name: A to Z"
        case nameZA = "Name: Z to A"
    }
    
    private struct Constant {
        static let path: String = "/products"
    }
    
    var availableBrands: [String] {
        let brands = products.map { $0.brand }
        return Array(Set(brands)).sorted()
    }
    
    private let productService: ProductClientProtocol
    
    init() {
        self.productService = ProductClient()
    }
    
    deinit {
        searchDebounceTimer?.invalidate()
    }
    
    // MARK: - Search Methods
    func updateSearchText(_ text: String) {
        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: searchDebounceDelay, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchText = text
            }
        }
    }
    
    func immediateSearch(_ text: String) {
        searchDebounceTimer?.invalidate()
        searchText = text
    }
    
    func clearSearch() {
        searchDebounceTimer?.invalidate()
        searchText = ""
    }
    
    func loadProducts() {
        currentPage = 0
        products = []
        hasMoreData = true
        loadMoreProducts()
    }
    
    func loadMoreProducts() {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        Task {
            let result = await productService.get(path: Constant.path, queryItems: nil)
            await MainActor.run {
                switch result {
                case .success(let newProducts):
                    if currentPage == 0 {
                        // İlk yüklemede tüm ürünleri al
                        self.allProducts = newProducts
                        self.products = Array(newProducts.prefix(itemsPerPage))
                    } else {
                        // Sayfalama: bir sonraki batch'i ekle
                        let startIndex = currentPage * itemsPerPage
                        let endIndex = min(startIndex + itemsPerPage, allProducts.count)
                        
                        if startIndex < allProducts.count {
                            let newBatch = Array(allProducts[startIndex..<endIndex])
                            self.products.append(contentsOf: newBatch)
                        }
                    }
                    
                    self.hasMoreData = self.products.count < self.allProducts.count
                    self.currentPage += 1
                    self.isLoading = false
                    self.filterProducts()
                    self.delegate?.productDidFetched()
                    
                case .failure(let failure):
                    self.isLoading = false
                    self.delegate?.productDidNotFetched(failure)
                }
            }
        }
    }
    
    func filterProducts() {
        var filtered = products
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText) ||
                product.model.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by brand
        if let brand = selectedBrand {
            filtered = filtered.filter { $0.brand == brand }
        }
        
        filteredProducts = filtered
        sortProducts()
        
        // Notify delegate that products have been filtered/searched
        delegate?.productDidFetched()
    }
    
    func sortProducts() {
        switch selectedSortOption {
        case .none:
            filteredProducts = filteredProducts.sorted { $0.id < $1.id }
        case .priceLowToHigh:
            filteredProducts = filteredProducts.sorted { (Double($0.price) ?? 0) < (Double($1.price) ?? 0) }
        case .priceHighToLow:
            filteredProducts = filteredProducts.sorted { (Double($0.price) ?? 0) > (Double($1.price) ?? 0) }
        case .nameAZ:
            filteredProducts = filteredProducts.sorted { $0.name < $1.name }
        case .nameZA:
            filteredProducts = filteredProducts.sorted { $0.name > $1.name }
        }
    }
    
    func clearFilters() {
        searchText = ""
        selectedBrand = nil
        selectedSortOption = .none
    }
    
    // MARK: - Favorite Management
    func toggleFavorite(for product: Product) {
        if FavoriteManager.shared.isFavorited(productId: product.id) {
            FavoriteManager.shared.removeFromFavorites(productId: product.id)
        } else {
            FavoriteManager.shared.addToFavorites(product: product)
        }
    }
    
    func isProductFavorited(productId: String) -> Bool {
        return FavoriteManager.shared.isFavorited(productId: productId)
    }
    
    func getIndexPathForProduct(_ product: Product) -> IndexPath? {
        guard let index = filteredProducts.firstIndex(where: { $0.id == product.id }) else {
            return nil
        }
        return IndexPath(item: index, section: 0)
    }
    
    func getProductService() -> ProductClientProtocol {
        return productService
    }
} 
