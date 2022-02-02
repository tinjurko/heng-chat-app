//
//  UITabBarItem+Extension.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation
import UIKit


extension UITabBarItem {
    static var home: UITabBarItem {
//        let selectedImage = UIImage(named: "")!.withRenderingMode(.alwaysOriginal)
//        let image = UIImage(named: "")!.withRenderingMode(.alwaysOriginal)
        
        let item = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        return item
    }
    
    static var map: UITabBarItem {
//        let selectedImage = UIImage(named: "")!.withRenderingMode(.alwaysOriginal)
//        let image = UIImage(named: "")!.withRenderingMode(.alwaysOriginal)
        
        let item = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        return item
    }
}
