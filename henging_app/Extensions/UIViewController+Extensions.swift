//
//  UIViewController+Extensions.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import Foundation
import UIKit

public protocol RootShowable: class {
    func showAsRoot()
}

extension RootShowable where Self: UIViewController {
    
    public func showAsRoot() {
        guard let window = window else {
            print("WARNING: no window!")
            return
        }
        
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
}

extension UIViewController: RootShowable {
    
    public var window: UIWindow? {
        var appWindow = view.window
        if appWindow == nil {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                appWindow = sceneDelegate.window
            }
        }
        
        return appWindow
    }
    
    public var contentViewController: UIViewController? {
        if let navigationViewController = self as? UINavigationController {
            return navigationViewController.topViewController?.contentViewController
        } else {
            return self
        }
    }
}

