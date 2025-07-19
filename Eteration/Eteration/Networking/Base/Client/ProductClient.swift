//
//  ProductClient.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

protocol ProductClientProtocol {
    func get(path: String, queryItems: [URLQueryItem]?) async -> Result<[Product], APIError>
}

struct ProductClient: ProductClientProtocol {
    var api: APIClient = {
        let configuration = URLSessionConfiguration.default
        return APIClient(configuration: configuration)
    }()
    
    func get(path: String,
             queryItems: [URLQueryItem]? = nil) async -> Result<[Product], APIError> {
        let response = await api.send(Request.get(path: path, queryItems: queryItems))
        switch response {
        case .success(let success):
            do {
                let model = try JSONDecoder().decode([Product].self, from: success)
                return .success(model)
            }
            catch {
                return .failure(.unhandledResponse)
            }
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
