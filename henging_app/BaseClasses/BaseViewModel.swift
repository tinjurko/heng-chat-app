//
//  BaseViewModel.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation

public typealias EmptyCallback = (() -> Void)

class BaseViewModel: NSObject {
    var onComplete: EmptyCallback?
    var onError: ((String) -> Void)?
    var onShowAlertMessage: ((String, String) -> Void)?
}
