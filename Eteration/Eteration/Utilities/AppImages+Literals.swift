//
//  AppImages+Literals.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit

// MARK: - Image Literals Extension
extension AppImages {
    
    // MARK: - Image Literals (Alternative Implementation)
    // Note: Image literals provide visual previews in Xcode but can cause version control issues
    // Use these as alternatives when you want visual representation in code
    
    /*
     To use image literals in Xcode:
     1. Type "image literal" in code
     2. Select from autocomplete
     3. Choose your image from the picker
     4. The image will appear inline in your code
     
     Example:
     static let homeLiteral = #imageLiteral(resourceName: "home")
     static let basketLiteral = #imageLiteral(resourceName: "basket")
     */
    
    // MARK: - Helper Methods for Image Literals
    static func createImageLiteral(named imageName: String) -> UIImage? {
        return UIImage(named: imageName)
    }
    
    // MARK: - Convenience Methods
    static func getTabBarImage(for tab: TabBarTab) -> UIImage? {
        switch tab {
        case .home:
            return homeTabIcon
        case .cart:
            return basketTabIcon
        case .favorites:
            return starTabIcon
        case .profile:
            return profileTabIcon
        }
    }
    
    static func getSystemImage(for systemIcon: SystemIcon, color: UIColor? = nil) -> UIImage? {
        let image: UIImage?
        switch systemIcon {
        case .magnifyingGlass:
            image = magnifyingGlass
        case .cart:
            image = cart
        case .heart:
            image = heart
        case .arrowLeft:
            image = arrowLeft
        case .photoFill:
            image = photoFill
        }
        
        if let color = color {
            return image?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
        return image
    }
}

// MARK: - Supporting Enums
enum TabBarTab {
    case home
    case cart
    case favorites
    case profile
}

enum SystemIcon {
    case magnifyingGlass
    case cart
    case heart
    case arrowLeft
    case photoFill
}

// MARK: - Usage Examples
/*
 
 // Traditional approach (recommended for version control)
 let homeImage = AppImages.home
 let cartIcon = AppImages.cart
 
 // Using helper methods
 let tabIcon = AppImages.getTabBarImage(for: .home)
 let systemIcon = AppImages.getSystemImage(for: .cart, color: .blue)
 
 // Using image literals (visual in Xcode but harder for version control)
 // let homeLiteral = #imageLiteral(resourceName: "home")
 
 // Dynamic favorite icon
 let favoriteIcon = AppImages.favoriteIcon(isFilled: true)
 
 // Configured system images
 let searchIcon = AppImages.magnifyingGlassIcon(color: .systemBlue)
 let backButton = AppImages.arrowLeftIcon(color: .white)
 
 */ 