//
//  Colors.swift
//
//  Created by Tin Jurković
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    // MARK: NEUTRAL
    static let greyMorgan = rgb(184, 184, 189)
    static let greyDeal = rgb(242, 242, 247)
    static let backgroundGrey = rgb(229, 229, 229)

    // MARK: SEMANTIC
    static let sendBirdPurple = rgb(108, 49, 212)
    
    static let homeOrange = rgb(252, 163, 17)
    static let tripsBlue = rgb(53, 129, 184)
    static let mapsRed = rgb(255, 105, 120)
    static let settingsGreen = rgb(71, 106, 111)
    
}
