//
//  BaseNavigationController.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        defaultLayout()
    }
    

    func defaultLayout() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
            self.navigationBar.isTranslucent = false
            self.navigationBar.tintColor = .sendBirdPurple

            return
        }

        // Fallback to other versions.
        self.navigationBar.tintColor = .sendBirdPurple
        self.navigationBar.barTintColor = .white
    }

}
