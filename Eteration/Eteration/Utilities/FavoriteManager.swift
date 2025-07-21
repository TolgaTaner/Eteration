//
//  FavoriteManager.swift
//  Eteration
//
//  Created by Tolga Taner on 21.07.2025.
//

// MARK: - FavoriteManager
final class FavoriteManager {
    
    static let shared = FavoriteManager()
    
    private let coreDataManager = CoreDataManager.shared
    
    private init() {}
    
    func addToFavorites(product: Product) {
        coreDataManager.saveFavoriteItem(productId: product.id)
    }
    
    func removeFromFavorites(productId: String) {
        coreDataManager.deleteFavoriteItem(productId: productId)
    }
    
    func isFavorited(productId: String) -> Bool {
        return coreDataManager.fetchFavoriteItem(productId: productId) != nil
    }
    
    func clearFavorites() {
        coreDataManager.clearFavorites()
    }
    
    func getFavoriteProductIds() -> [String] {
        let favoriteItems = coreDataManager.fetchFavoriteItems()
        return favoriteItems.compactMap { item in
            return item.value(forKey: AppConstants.productIdAttribute) as? String
        }
    }
}
