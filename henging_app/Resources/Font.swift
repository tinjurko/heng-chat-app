//
//  Font.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import UIKit

enum Font: String {
    case bold
    case semiBold
    case medium
    case regular

    var name: String {
        return self.rawValue
    }
    
    func size(_ size: CGFloat) -> UIFont {
        let weight: UIFont.Weight!
        
        switch self {
        case .bold:
            weight = UIFont.Weight.bold
        case .semiBold:
            weight = UIFont.Weight.semibold
        case .medium:
            weight = UIFont.Weight.medium
        case .regular:
            weight = UIFont.Weight.regular
        }
        
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}
