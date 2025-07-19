//
//  APIClient.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

enum HTTPMethod: String {
    case get
}

struct APIClient {
    
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        session = URLSession(configuration: configuration)
    }
    
    func send(_ request: Request) async -> Result<Data, APIError> {
        guard let urlRequest = request.builder.toURLRequest()
        else {
            assertionFailure("wrong base url")
            return .failure(.unknownResponse)
        }
        debugPrint("URL:", request.builder.toURLRequest()?.url?.absoluteString)
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            if let error = APIError.error(from: response) {
                return .failure(error)
            }
            return .success(data)
        } catch {
            return .failure(.unknownResponse)
        }
    }
    
}
