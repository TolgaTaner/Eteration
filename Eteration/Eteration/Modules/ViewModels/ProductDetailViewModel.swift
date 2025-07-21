//
//  ProductDetailViewModel.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

protocol ProductDetailViewModelDelegate: AnyObject {
    func productDidUpdate()
    func loadingStateDidChange(_ isLoading: Bool)
    func favoriteStateDidChange(_ isFavorited: Bool)
}

final class ProductDetailViewModel {
    
    weak var delegate: ProductDetailViewModelDelegate?
    
    var product: Product?
    
    var isLoading: Bool = false {
        didSet {
            delegate?.loadingStateDidChange(isLoading)
        }
    }
    
    var isFavorited: Bool = false {
        didSet {
            delegate?.favoriteStateDidChange(isFavorited)
        }
    }
    
    private let cartManager: CartManager
    private let favoriteManager: FavoriteManager
    
    init(
        product: Product,
        cartManager: CartManager = CartManager.shared,
        favoriteManager: FavoriteManager = FavoriteManager.shared
    ) {
        self.product = product
        self.cartManager = cartManager
        self.favoriteManager = favoriteManager
        
        checkFavoriteStatus()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
        
        // Immediately notify that product is available
        DispatchQueue.main.async {
            self.delegate?.productDidUpdate()
        }
    }
    
    // Product is now passed directly, no need to load from API
    
    func addToCart() {
        guard let product = product else { 
            return
        }
        cartManager.addToCart(product: product)
    }
    
    func toggleFavorite() {
        guard let product = product else { return }
        
        if isFavorited {
            favoriteManager.removeFromFavorites(productId: product.id)
        } else {
            favoriteManager.addToFavorites(product: product)
        }
        
        // The notification system will handle updating the UI
        // via favoritesDidChange -> checkFavoriteStatus
    }
    
    @objc private func favoritesDidChange() {
        checkFavoriteStatus()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func checkFavoriteStatus() {
        guard let product = product else { return }
        isFavorited = favoriteManager.isFavorited(productId: product.id)
        delegate?.favoriteStateDidChange(isFavorited)
    }
} 
