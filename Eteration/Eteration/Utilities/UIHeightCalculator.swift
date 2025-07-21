//
//  UIHeightCalculator.swift
//  Eteration
//
//  Created by Tolga Taner on 20.07.2025.
//

import UIKit

final class UIHeightCalculator {
    
    /// Calculates the total height of status bar and navigation bar
    /// - Parameter viewController: The view controller to calculate heights for
    /// - Returns: The total height of status bar + navigation bar
    static func calculateTotalHeight(for viewController: UIViewController) -> CGFloat {
        let statusBarHeight = viewController.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight = viewController.navigationController?.navigationBar.frame.height ?? 0
        return statusBarHeight + navBarHeight
    }
    
    /// Calculates only the status bar height
    /// - Parameter viewController: The view controller to calculate status bar height for
    /// - Returns: The status bar height
    static func calculateStatusBarHeight(for viewController: UIViewController) -> CGFloat {
        return viewController.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    /// Calculates only the navigation bar height
    /// - Parameter viewController: The view controller to calculate navigation bar height for
    /// - Returns: The navigation bar height
    static func calculateNavigationBarHeight(for viewController: UIViewController) -> CGFloat {
        return viewController.navigationController?.navigationBar.frame.height ?? 0
    }
}
