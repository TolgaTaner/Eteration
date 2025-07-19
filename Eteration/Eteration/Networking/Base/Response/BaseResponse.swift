//
//  BaseResponse.swift
//  Eteration
//
//  Created by Tolga Taner on 18.07.2025.
//

import Foundation

struct BaseResponse<T: Model>: Model {
    let status: String
    let data: T
}
