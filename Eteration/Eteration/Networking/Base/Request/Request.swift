//
//  Request.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

struct Request {
    let builder: RequestBuilder
    
    init(builder: RequestBuilder) {
        self.builder = builder
    }
    
    static func get(method: HTTPMethod = .get,
                    path: String,
                    queryItems: [URLQueryItem]?) -> Request {
        let builder = GetRequestBuilder(method: method,
                                        endpoint: Endpoint(path: path,
                                                           queryItems: queryItems ?? nil))
        return Request(builder: builder)
    }
    
}

extension Result where Success == Data, Failure == APIError {
    func decoding<M: Model>(_ model: M.Type) async -> Result<M, APIError> {
        let result = flatMap { data -> Result<M, APIError> in
            do {
                let decoder = M.decoder
                let model = try decoder.decode(M.self, from: data)
                return .success(model)
            } catch let e as DecodingError {
                return .failure(.decodingError(e))
            } catch {
                return .failure(APIError.unhandledResponse)
            }
        }
        return result
    }
}
