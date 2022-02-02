//
//  APIRouter.swift
//  henging_app
//
//  Created by Tin Jurkovic on 02.02.2022..
//

import Alamofire

// API Router prepared for adding more routes
enum APIRouter: URLRequestConvertible {
    case getUser(String) //user_id

    var path: String {
        switch self {
        case .getUser(let userID):
            return "/users/\(userID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        }
    }

    var parameters: Parameters {
        return [:]
    }

    var authorization: String? {
        if let masterToken = Bundle.main.object(forInfoDictionaryKey: "SENDBIRD_MASTER_TOKEN") as? String {
            return masterToken
        }

        return nil
    }


    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Config.SendBird.baseURL)
        var urlRequest = try URLRequest(url: (url?.appendingPathComponent(path))!, method: method)

        if let authorization = authorization {
            urlRequest.addValue(authorization, forHTTPHeaderField: "Api-Token")
        }

        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
