//
//  LocalUser.swift
//  henging_app
//
//  Created by Tin Jurkovic on 31.01.2022..
//

import Foundation
import UIKit

class LocalUser {
    var id: String!
    var name: String!
    var image: UIImage?

    init(id: String, name: String, image: UIImage?) {
        self.id = id
        self.name = name
        self.image = image
    }
}
