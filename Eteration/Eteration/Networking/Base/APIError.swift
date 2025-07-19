//
//  APIError.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

enum APIError: Error, Equatable {

    case unknownResponse
    case networkError(Error)
    case requestError(Int)
    case serverError(Int)
    case decodingError(DecodingError)
    case unhandledResponse

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.unknownResponse, .unknownResponse):
            return true
        case (.networkError, .networkError):
            return true
        case (.requestError(let lhsCode), .requestError(let rhsCode)):
            return lhsCode == rhsCode
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.decodingError, .decodingError):
            return true
        case (.unhandledResponse, .unhandledResponse):
            return true
        default:
            return false
        }
    }
}

extension APIError {

    static func error(from response: URLResponse?) -> APIError? {
        guard let http = response as? HTTPURLResponse
        else {
            return .unknownResponse
        }
        switch http.statusCode {
        case 200: return nil
        case 401: return .requestError(http.statusCode)
        case 404: return .requestError(http.statusCode)
        case 500...599: return .serverError(http.statusCode)
        default: return .unhandledResponse
        }
    }
}
