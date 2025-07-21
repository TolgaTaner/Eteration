//
//  CartManager.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation
import CoreData

// MARK: - CartManager
final class CartManager {
    
    static let shared = CartManager()
    private init() {}
    
    private var context: NSManagedObjectContext {
        return CoreDataManager.shared.context
    }
    
    // MARK: - Public Methods
    func addToCart(product: Product) {
        
        // Check if product already exists in cart
        if let existingItem = getCartItem(for: product.id) {
            // Increase quantity
            let currentQuantity = existingItem.value(forKey: AppConstants.quantityAttribute) as? Int32 ?? 0
            existingItem.setValue(currentQuantity + 1, forKey: AppConstants.quantityAttribute)
        } else {
            print("CartManager: Creating new cart item") // Debug print
            // Create new cart item
            let cartItem = NSEntityDescription.insertNewObject(forEntityName: AppConstants.cartItemEntity, into: context)
            cartItem.setValue(product.id, forKey: AppConstants.productIdAttribute)
            cartItem.setValue(Int32(1), forKey: AppConstants.quantityAttribute)
            cartItem.setValue(Date(), forKey: AppConstants.dateAddedAttribute)
        }
        
        CoreDataManager.shared.saveContext()
        NotificationCenter.default.post(name: .cartDidChange, object: nil)
        print("CartManager: Product added to cart successfully") // Debug print
    }
    
    func removeFromCart(product: Product) {
        if let cartItem = getCartItem(for: product.id) {
            context.delete(cartItem)
            CoreDataManager.shared.saveContext()
            NotificationCenter.default.post(name: .cartDidChange, object: nil)
        }
    }
    
    func increaseQuantity(for product: Product) {
        if let existingItem = getCartItem(for: product.id) {
            let currentQuantity = existingItem.value(forKey: AppConstants.quantityAttribute) as? Int32 ?? 0
            existingItem.setValue(currentQuantity + 1, forKey: AppConstants.quantityAttribute)
            CoreDataManager.shared.saveContext()
            NotificationCenter.default.post(name: .cartDidChange, object: nil)
        }
    }
    
    func decreaseQuantity(for product: Product) {
        if let existingItem = getCartItem(for: product.id) {
            let currentQuantity = existingItem.value(forKey: AppConstants.quantityAttribute) as? Int32 ?? 0
            if currentQuantity > 1 {
                existingItem.setValue(currentQuantity - 1, forKey: AppConstants.quantityAttribute)
                CoreDataManager.shared.saveContext()
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
            } else {
                // Remove item if quantity would be 0
                context.delete(existingItem)
                CoreDataManager.shared.saveContext()
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
            }
        }
    }
    
    func getCartItemIds() -> [CartItemId] {
        let request = NSFetchRequest<NSManagedObject>(entityName: AppConstants.cartItemEntity)
        
        do {
            let items = try context.fetch(request)
            return items.compactMap { item in
                guard let productId = item.value(forKey: AppConstants.productIdAttribute) as? String,
                      let quantity = item.value(forKey: AppConstants.quantityAttribute) as? Int32 else {
                    return nil
                }
                return CartItemId(productId: productId, quantity: Int(quantity))
            }
        } catch {
            print("Error fetching cart items: \(error)")
            return []
        }
    }
    
    func getQuantity(for productId: String) -> Int {
        if let cartItem = getCartItem(for: productId) {
            let quantity = cartItem.value(forKey: AppConstants.quantityAttribute) as? Int32 ?? 0
            return Int(quantity)
        }
        return 0
    }
    
    func getTotalItemCount() -> Int {
        let cartItems = getCartItemIds()
        return cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    func clearCart() {
        let request = NSFetchRequest<NSManagedObject>(entityName: AppConstants.cartItemEntity)
        
        do {
            let items = try context.fetch(request)
            for item in items {
                context.delete(item)
            }
            CoreDataManager.shared.saveContext()
            NotificationCenter.default.post(name: .cartDidChange, object: nil)
        } catch {
            print("Error clearing cart: \(error)")
        }
    }
    
    // MARK: - Private Methods
    private func getCartItem(for productId: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: AppConstants.cartItemEntity)
        request.predicate = NSPredicate(format: "productId == %@", productId)
        request.fetchLimit = 1
        
        do {
            let items = try context.fetch(request)
            return items.first
        } catch {
            print("Error fetching cart item: \(error)")
            return nil
        }
    }

}

// MARK: - Supporting Types
struct CartItemId {
    let productId: String
    let quantity: Int
}



