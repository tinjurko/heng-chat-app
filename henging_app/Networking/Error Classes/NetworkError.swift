//
//  NetworkError.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation

class NetworkError: Codable {
    var error: ResponseError
    
    init(type: NetworkErrorType) {
        self.error = ResponseError(type: type)
    }
    
    init(message: String) {
        self.error = ResponseError(message: message)
    }
    
    func getMessage() -> String {
        return error.message
    }
}

struct ResponseError: Codable {
    var message: String
    var type: NetworkErrorType?
    
    init(type: NetworkErrorType) {
        self.type = type
        self.message = type.rawValue
    }
    
    init(message: String) {
        self.type = .unknown
        self.message = message
    }
}
