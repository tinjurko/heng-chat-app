//
//  Config.swift
//  henging_app
//
//  Created by Tin Jurkovic on 30.01.2022..
//

import Foundation
import UIKit


class Config {
    struct SendBird {
        static var appID = "0EC17749-A231-4D78-8DC1-129BB0EC0BFA"
        static var baseURL = "https://api-\(appID).sendbird.com/v3"
        static var uniqueDelegateID = "129BB0EC0BFA-d3l3gat3"
    }

    struct LocalUsers {
        static let user01 = LocalUser(id: "testUser01", name: "Mark", image: UIImage(imageLiteralResourceName: "user01"))
        static let user02 = LocalUser(id: "testUser02", name: "Lisa", image: UIImage(imageLiteralResourceName: "user02"))
    }
}
