//
//  CoreDataManager.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let managedObjectModel = NSManagedObjectModel()
        
        let cartItemEntity = NSEntityDescription()
        cartItemEntity.name = AppConstants.cartItemEntity
        cartItemEntity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        
        let productIdAttribute = NSAttributeDescription()
        productIdAttribute.name = AppConstants.productIdAttribute
        productIdAttribute.attributeType = .stringAttributeType
        productIdAttribute.isOptional = false
        
        let quantityAttribute = NSAttributeDescription()
        quantityAttribute.name = AppConstants.quantityAttribute
        quantityAttribute.attributeType = .integer32AttributeType
        quantityAttribute.isOptional = false
        
        let dateAddedAttribute = NSAttributeDescription()
        dateAddedAttribute.name = AppConstants.dateAddedAttribute
        dateAddedAttribute.attributeType = .dateAttributeType
        dateAddedAttribute.isOptional = false
        
        cartItemEntity.properties = [productIdAttribute, quantityAttribute, dateAddedAttribute]
        
        let favoriteItemEntity = NSEntityDescription()
        favoriteItemEntity.name = AppConstants.favoriteItemEntity
        favoriteItemEntity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        
        let favoriteProductIdAttribute = NSAttributeDescription()
        favoriteProductIdAttribute.name = AppConstants.productIdAttribute
        favoriteProductIdAttribute.attributeType = .stringAttributeType
        favoriteProductIdAttribute.isOptional = false
        
        let favoriteDateAddedAttribute = NSAttributeDescription()
        favoriteDateAddedAttribute.name = AppConstants.dateAddedAttribute
        favoriteDateAddedAttribute.attributeType = .dateAttributeType
        favoriteDateAddedAttribute.isOptional = false
        
        favoriteItemEntity.properties = [favoriteProductIdAttribute, favoriteDateAddedAttribute]
        
        managedObjectModel.entities = [cartItemEntity, favoriteItemEntity]
        
        let container = NSPersistentContainer(name: AppConstants.dataModelName, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                NotificationCenter.default.post(name: .coreDataDidSave, object: nil)
            } catch {
                let nsError = error as NSError
                fatalError("CoreData save error: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Cart Operations
    func saveCartItem(productId: String, quantity: Int32) {
        // Check if item already exists
        if let existingItem = fetchCartItem(productId: productId) {
            existingItem.setValue(quantity, forKey: "quantity")
        } else {
            let cartItem = NSEntityDescription.entity(forEntityName: "CartItem", in: context)!
            let newCartItem = NSManagedObject(entity: cartItem, insertInto: context)
            newCartItem.setValue(productId, forKey: "productId")
            newCartItem.setValue(quantity, forKey: "quantity")
            newCartItem.setValue(Date(), forKey: "dateAdded")
        }
        saveContext()
        NotificationCenter.default.post(name: .cartDidChange, object: nil)
    }
    
    func fetchCartItems() -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CartItem")
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching cart items: \(error)")
            return []
        }
    }
    
    func fetchCartItem(productId: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CartItem")
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
    
    func deleteCartItem(productId: String) {
        if let item = fetchCartItem(productId: productId) {
            context.delete(item)
            saveContext()
            NotificationCenter.default.post(name: .cartDidChange, object: nil)
        }
    }
    
    func clearCart() {
        let items = fetchCartItems()
        items.forEach { context.delete($0) }
        saveContext()
        NotificationCenter.default.post(name: .cartDidChange, object: nil)
    }
    
    // MARK: - Favorite Operations
    func saveFavoriteItem(productId: String) {
        // Check if already favorited
        if fetchFavoriteItem(productId: productId) != nil {
            return
        }
        
        let favoriteItem = NSEntityDescription.entity(forEntityName: "FavoriteItem", in: context)!
        let newFavoriteItem = NSManagedObject(entity: favoriteItem, insertInto: context)
        newFavoriteItem.setValue(productId, forKey: "productId")
        newFavoriteItem.setValue(Date(), forKey: "dateAdded")
        
        saveContext()
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    func fetchFavoriteItems() -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteItem")
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favorite items: \(error)")
            return []
        }
    }
    
    func fetchFavoriteItem(productId: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteItem")
        request.predicate = NSPredicate(format: "productId == %@", productId)
        request.fetchLimit = 1
        
        do {
            let items = try context.fetch(request)
            return items.first
        } catch {
            print("Error fetching favorite item: \(error)")
            return nil
        }
    }
    
    func deleteFavoriteItem(productId: String) {
        if let item = fetchFavoriteItem(productId: productId) {
            context.delete(item)
            saveContext()
            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        }
    }
    
    func clearFavorites() {
        let items = fetchFavoriteItems()
        items.forEach { context.delete($0) }
        saveContext()
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
}

// MARK: - Notification Names Extension
extension Notification.Name {
    static let coreDataDidSave = Notification.Name("coreDataDidSave")
} 
