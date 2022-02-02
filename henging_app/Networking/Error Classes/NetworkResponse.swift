//
//  NetworkResponse.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation

enum NetworkResponse<T: Decodable> {
    case success(T)
    case failure(NetworkError)
}
