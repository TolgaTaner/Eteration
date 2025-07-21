//
//  CartItem.swift
//  Eteration
//
//  Created by Tolga Taner on 21.07.2025.
//

import Foundation

struct CartItem {
    let product: Product
    let quantity: Int
    
    var totalPrice: Double {
        return (Double(product.price) ?? 0.0) * Double(quantity)
    }
    
    var formattedTotalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let formattedNumber = formatter.string(from: NSNumber(value: totalPrice)) ?? "0"
        return "\(formattedNumber) ₺"
    }
}
