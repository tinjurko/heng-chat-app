//
//  APIManager.swift
//  henging_app
//
//  Created by Tin Jurkovic on 02.02.2022..
//

import Alamofire

class APIManager {
    static func getUser(userID: String, onComplete: @escaping (NetworkResponse<SBDUserModel>) -> Void) {
        AF.request(APIRouter.getUser(userID)).responseData { response in
            APINetworkData.responseHandler(dataType: SBDUserModel.self, response: response) { response in
                onComplete(response)
            }
        }
    }
}

