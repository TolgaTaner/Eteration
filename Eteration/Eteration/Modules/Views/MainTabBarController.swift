//
//  MainTabBarController.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupCartBadge()
        let itemCount = CartManager.shared.getTotalItemCount()
        updateCartBadge(itemCount: itemCount)
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .systemGray
        
        // Add shadow to tab bar
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 10, height: 0)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.masksToBounds = false
        
        // Create shared ProductListViewModel
        let sharedProductListViewModel = ProductListViewModel()
        
        let homeViewController = ProductListViewController()
        let cartViewController = CartViewController()
        let favoritesViewController = FavoritesViewController()
        let profileViewController = ProfileViewController()
        
        // Set the shared view model for both home and cart
        homeViewController.setSharedProductListViewModel(sharedProductListViewModel)
        cartViewController.setSharedProductListViewModel(sharedProductListViewModel)
        
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        let cartNavController = UINavigationController(rootViewController: cartViewController)
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        
        homeViewController.navigationController?.setNavigationBarHidden(true, animated: false)
        cartViewController.navigationController?.setNavigationBarHidden(true, animated: false)
        favoritesViewController.navigationController?.setNavigationBarHidden(true, animated: false)
        profileViewController.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let homeImage = AppImages.homeTabIcon
        let basketImage = AppImages.basketTabIcon
        let starImage = AppImages.starTabIcon
        let profileImage = AppImages.profileTabIcon
        
        homeNavController.tabBarItem = UITabBarItem(
            title: AppConstants.emptyTitle,
            image: homeImage,
            selectedImage: homeImage
        )
        
        cartNavController.tabBarItem = UITabBarItem(
            title: AppConstants.emptyTitle,
            image: basketImage,
            selectedImage: basketImage
        )
        
        favoritesNavController.tabBarItem = UITabBarItem(
            title: AppConstants.emptyTitle,
            image: starImage,
            selectedImage: starImage
        )
        
        profileNavController.tabBarItem = UITabBarItem(
            title: AppConstants.emptyTitle,
            image: profileImage,
            selectedImage: profileImage
        )
        viewControllers = [homeNavController, cartNavController, favoritesNavController, profileNavController]
    }
    
    private func setupCartBadge() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartDidChange),
            name: .cartDidChange,
            object: nil
        )
    }
    
    @objc private func cartDidChange() {
        let itemCount = CartManager.shared.getTotalItemCount()
        updateCartBadge(itemCount: itemCount)
    }
    
    private func updateCartBadge(itemCount: Int) {
        guard let tabBarItems = tabBar.items, tabBarItems.count > 1 else { return }
        
        let cartTabBarItem = tabBarItems[1] // Cart is the second tab
        
        if itemCount > 0 {
            cartTabBarItem.badgeValue = "\(itemCount)"
            cartTabBarItem.badgeColor = .systemRed
        } else {
            cartTabBarItem.badgeValue = nil
        }
    }
}
