//
//  AppImages.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import UIKit

struct AppImages {
    
    // MARK: - System Images
    static let magnifyingGlass = UIImage(systemName: "magnifyingglass")
    static let cart = UIImage(systemName: "cart")
    static let heart = UIImage(systemName: "heart")
    static let arrowLeft = UIImage(systemName: "arrow.left")
    static let photoFill = UIImage(systemName: "photo.fill")
    
    // MARK: - Custom Asset Images
    static let home = UIImage(named: "home")
    static let basket = UIImage(named: "basket")
    static let star = UIImage(named: "star")
    static let profile = UIImage(named: "profile")
    static let iconUnfillStar = UIImage(named: "icon_unfillstar")
    static let iconFillStar = UIImage(named: "icon_fillstar")
    
    // MARK: - Tab Bar Images (with rendering mode)
    static let homeTabIcon = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
    static let basketTabIcon = UIImage(named: "basket")?.withRenderingMode(.alwaysOriginal)
    static let starTabIcon = UIImage(named: "star")?.withRenderingMode(.alwaysOriginal)
    static let profileTabIcon = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
    
    // MARK: - Favorite Icons (for different states)
    static func favoriteIcon(isFilled: Bool) -> UIImage? {
        return isFilled ? iconFillStar : iconUnfillStar
    }
    
    // MARK: - System Images with Configuration
    static func magnifyingGlassIcon(color: UIColor = .systemGray2) -> UIImage? {
        return magnifyingGlass?.withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    static func cartIcon(color: UIColor = .label) -> UIImage? {
        return cart?.withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    static func heartIcon(color: UIColor = .systemGray3) -> UIImage? {
        return heart?.withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    static func arrowLeftIcon(color: UIColor = .white) -> UIImage? {
        return arrowLeft?.withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    static func photoFillIcon(color: UIColor = .systemGray4) -> UIImage? {
        return photoFill?.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
