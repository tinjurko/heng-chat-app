//
//  Coordinator.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator: class {
    
    @discardableResult
    func start() -> UIViewController
}
