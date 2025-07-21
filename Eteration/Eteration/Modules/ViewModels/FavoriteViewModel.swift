//
//  FavoriteViewModel.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

protocol FavoriteViewModelDelegate: AnyObject {
    func favoritesDidUpdate()
}

final class FavoriteViewModel {
    
    weak var delegate: FavoriteViewModelDelegate?
    var favoriteProductIds: [String] = []
    
    private let favoriteManager: FavoriteManager
    
    init(favoriteManager: FavoriteManager = FavoriteManager.shared) {
        self.favoriteManager = favoriteManager
        self.favoriteProductIds = favoriteManager.getFavoriteProductIds()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
    }
    
    @objc private func favoritesDidChange() {
        favoriteProductIds = favoriteManager.getFavoriteProductIds()
        delegate?.favoritesDidUpdate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func removeFromFavorites(product: Product) {
        favoriteManager.removeFromFavorites(productId: product.id)
    }
    
    func clearFavorites() {
        favoriteManager.clearFavorites()
    }
}
