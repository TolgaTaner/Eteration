//
//  CartViewModel.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

protocol CartViewModelDelegate: AnyObject {
    func cartDidUpdate()
    func loadingStateDidChange(_ isLoading: Bool)
}

final class CartViewModel {
    
    weak var delegate: CartViewModelDelegate?
    
    private let cartManager: CartManager
    private var productListViewModel: ProductListViewModel
    
    var cartItems: [CartItem] = []
    var isLoading: Bool = false {
        didSet {
            delegate?.loadingStateDidChange(isLoading)
        }
    }
    var totalPrice: Double {
        return cartItems.reduce(0.0) { $0 + $1.totalPrice }
    }
    
    init(cartManager: CartManager = CartManager.shared, productListViewModel: ProductListViewModel = ProductListViewModel()) {
        self.cartManager = cartManager
        self.productListViewModel = productListViewModel
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidChange),
            name: .cartDidChange,
            object: nil
        )
    }
    
    func setSharedProductListViewModel(_ productListViewModel: ProductListViewModel) {
        self.productListViewModel = productListViewModel
    }
    
    @objc private func cartDidChange() {
        loadCartItems()
        delegate?.cartDidUpdate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadCartItems() {
        let cartItemIds = cartManager.getCartItemIds()
        cartItems = []
        
        // If we don't have products loaded, we need to load them first
        if productListViewModel.allProducts.isEmpty {
            isLoading = true
            loadProductsAndCartItems()
        } else {
            for cartItemId in cartItemIds {
                if let product = productListViewModel.allProducts.first(where: { $0.id == cartItemId.productId }) {
                    cartItems.append(CartItem(product: product, quantity: cartItemId.quantity))
                }
            }
            delegate?.cartDidUpdate()
        }
    }
    
    private func loadProductsAndCartItems() {
        Task {
            let result = await productListViewModel.getProductService().get(path: "/products", queryItems: nil)
            await MainActor.run {
                self.isLoading = false
                switch result {
                case .success(let products):
                    self.productListViewModel.allProducts = products
                    self.loadCartItemsFromLoadedProducts()
                case .failure(_):
                    // Handle error if needed
                    break
                }
            }
        }
    }
    
    private func loadCartItemsFromLoadedProducts() {
        let cartItemIds = cartManager.getCartItemIds()
        cartItems = []
        
        for cartItemId in cartItemIds {
            if let product = productListViewModel.allProducts.first(where: { $0.id == cartItemId.productId }) {
                cartItems.append(CartItem(product: product, quantity: cartItemId.quantity))
            }
        }
        
        delegate?.cartDidUpdate()
    }
    
    func increaseQuantity(for product: Product) {
        cartManager.increaseQuantity(for: product)
    }
    
    func decreaseQuantity(for product: Product) {
        cartManager.decreaseQuantity(for: product)
    }
    
    func removeFromCart(product: Product) {
        cartManager.removeFromCart(product: product)
    }
    
    func clearCart() {
        cartManager.clearCart()
    }
    
    func completeOrder() {
        clearCart()
    }
} 
