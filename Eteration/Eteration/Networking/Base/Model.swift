//
//  Model.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

protocol Model: Decodable {
    static var decoder: JSONDecoder { get }
}

extension Model {
     static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
