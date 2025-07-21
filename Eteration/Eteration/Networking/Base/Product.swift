//
//  Product.swift
//  Eteration
//
//  Created by Tolga Taner on 19.07.2025.
//

struct Product: Model {
    let createdAt, name: String
    let image: String
    let price, description, model, brand: String
    let id: String
    
    init(createdAt: String, name: String, image: String, price: String, description: String, model: String, brand: String, id: String) {
        self.createdAt = createdAt
        self.name = name
        self.image = image
        self.price = price
        self.description = description
        self.model = model
        self.brand = brand
        self.id = id
    }
}
