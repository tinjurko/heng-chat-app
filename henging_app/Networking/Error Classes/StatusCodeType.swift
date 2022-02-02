//
//  StatusCodeType.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation

enum StatusCodeType: Int {
    case OK = 200
    case Created = 201
    case BadRequest = 400
    case Unauthorized = 401
    case NotFound = 404
    case ValidationError = 422
    case InternalServerError = 500
    case unknow = 00
}

