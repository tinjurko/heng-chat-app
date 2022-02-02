//
//  APIDataDeserializer.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Alamofire
import Reachability

class APINetworkData {
    static func responseHandler<T: Codable>(dataType: T.Type, response: AFDataResponse<Data>, onComplete: @escaping (NetworkResponse<T>) -> Void) {
        if !isNetworkConnectionAvailable() {
            onComplete(.failure(NetworkError(type: .noConnection)))
            return
        }
        
        let statusCode = response.response?.statusCode ?? 00
        guard let statusCodeType = StatusCodeType(rawValue: statusCode) else {
            onComplete(.failure(NetworkError(type: .unknown)))
            return
        }

        switch response.result {
        case .success(let data):
            switch statusCodeType {
            case .OK, .Created:
                guard let encodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    onComplete(.failure(NetworkError(type: .parse)))
                    return
                }
                
                onComplete(.success(encodedData))
            case .BadRequest:
                onComplete(.failure(NetworkError(type: .badRequest)))
            case .Unauthorized:
                onComplete(.failure(NetworkError(type: .unauthorized)))
            case .NotFound:
                onComplete(.failure(NetworkError(type: .notFound)))
            case .ValidationError:
                guard let error = try? JSONDecoder().decode(NetworkError.self, from: data) else {
                    onComplete(.failure(NetworkError(type: .parse)))
                    return
                }
                
                onComplete(.failure(error))
            case .InternalServerError:
                onComplete(.failure(NetworkError(type: .internalServer)))
            default:
                onComplete(.failure(NetworkError(type: .failure)))
            }
        case .failure:
            onComplete(.failure(NetworkError(type: .failure)))
        }
    }
    
    private static func isNetworkConnectionAvailable() -> Bool {
        guard let reachability = try? Reachability() else { return true }
        
        let status = reachability.connection
        
        if status == .unavailable {
            return false
        } else {
            return true
        }
    }
}
