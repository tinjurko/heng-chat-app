//
//  ErrorMessages.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation

enum NetworkErrorType: String, Codable {
    case parse = "Couldn't parse data!"
    case failure = "Something went wrong."
    case noConnection  = "No connection!"
    case internalServer = "Internal Server Error."
    case badRequest = "Bad request."
    case unauthorized = "Unauthorized"
    case notFound = "Not found."
    case unknown 
}
