//
//  Endpoint.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem]?
    let environment: AppEnvironment = AppEnvironment()
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = environment.scheme
        components.host = environment.baseUrl
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}


