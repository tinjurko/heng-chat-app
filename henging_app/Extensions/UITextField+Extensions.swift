//
//  UITextField+Extensions.swift
//  henging_app
//
//  Created by Tin Jurkovic on 01.02.2022..
//

import UIKit

extension UITextField {
    func contentInset(left amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func contentInset(right amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }

    func contentInsets(left leftAmount: CGFloat, right rightAmount: CGFloat) {
        contentInset(left: leftAmount)
        contentInset(right: rightAmount)
    }

    func setPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
