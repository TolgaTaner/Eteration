//
//  AppConstants.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

struct AppConstants {
    
    // MARK: - App Branding
    static let appName = "E-Market"
    
    // MARK: - Button Titles
    static let addToCart = "Add to Cart"
    static let complete = "Complete"
    static let completeOrder = "Complete Order"
    static let cancel = "Cancel"
    static let ok = "OK"
    static let remove = "Remove"
    static let clearAllFilters = "Clear All Filters"
    static let allBrands = "All Brands"
    
    // MARK: - Navigation & UI Labels
    static let search = "Search"
    static let selectFilter = "Select Filter"
    static let filters = "Filters:"
    static let price = "Price:"
    static let total = "Total:"
    static let model = "Model:"
    
    // MARK: - Empty State Messages
    static let noProductsFound = "No products found"
    static let noFavoritesYet = "No favorites yet"
    static let cartEmpty = "Your cart is empty"
    static let addProductsToGetStarted = "Add some products to get started"
    static let tapHeartToAddFavorites = "Tap the heart icon on products to add them to your favorites"
    
    // MARK: - Alert Titles & Messages
    static let addedToCart = "Added to Cart"
    static let productAddedToCart = "Product has been added to your cart"
    static let orderCompleted = "Order Completed"
    static let orderCompletedMessage = "Your order has been successfully placed!"
    static let completeOrderConfirmation = "Are you sure you want to complete your order?"
    static let filteringAndSorting = "Filtering and sorting options"
    
    // MARK: - Sort Options
    static let sortDefault = "Default"
    static let sortPriceLowToHigh = "Price: Low to High"
    static let sortPriceHighToLow = "Price: High to Low"
    static let sortNameAZ = "Name: A to Z"
        static let sortNameZA = "Name: Z to A"
    
    // MARK: - Currency & Formatting
    static let turkishLira = "₺"
    static let currencyCode = "TRY"
    static let turkishLocale = "tr_TR"
    static let groupingSeparator = "."
    static let decimalSeparator = ","
    
    // MARK: - Button Symbols
    static let decreaseSymbol = "−"
    static let increaseSymbol = "+"
    
    // MARK: - Core Data Entities
    static let cartItemEntity = "CartItem"
    static let favoriteItemEntity = "FavoriteItem"
    static let dataModelName = "DataModel"
    
    // MARK: - Core Data Attributes
    static let productIdAttribute = "productId"
    static let quantityAttribute = "quantity"
    static let dateAddedAttribute = "dateAdded"
    
    // MARK: - Cell Identifiers
    static let productCollectionViewCellId = "ProductCollectionViewCell"
    static let cartItemTableViewCellId = "CartItemTableViewCell"
    static let loadingFooterViewId = "LoadingFooterView"
    
    // MARK: - API Endpoints
    static let productsPath = "/products"
    
    // MARK: - Notification Names
    static let cartDidChangeNotification = "cartDidChange"
    static let favoritesDidChangeNotification = "favoritesDidChange"
    
    // MARK: - Configuration Names
    static let defaultConfiguration = "Default Configuration"
    static let launchScreen = "Launch Screen"
    
    // MARK: - CoreData Keys
    static let checkedKey = "checked"
    
    // MARK: - Tab Bar
    static let emptyTitle = ""
    
    // MARK: - Fallback Values
    static let fallbackPrice = "0"
    static let fallbackPriceWithSymbol = "0₺"
}
