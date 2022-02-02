//
//  BaseViewController.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var hideKeyboardIfNeeded: Bool = false {
        didSet{
            if hideKeyboardIfNeeded {
                setupHideKeyboardIfNeeded()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        invisibleNavigationBar()
        removeNavigationBarBackButtonTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func removeNavigationBackButton() {
        self.navigationController?.navigationItem.leftBarButtonItem = nil
    }
    
    func invisibleNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func removeNavigationBarBackButtonTitle() {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setupHideKeyboardIfNeeded() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endViewEditing)))
    }
    
    @objc private func endViewEditing() {
        self.view.endEditing(true)
    }
    
    public func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showAlert(message: String, onComplete: @escaping EmptyCallback) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            onComplete()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showTitleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showTitleAlert(title: String, message: String, onComplete: @escaping EmptyCallback) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            onComplete()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showCustomAlert(title: String, actionTitle: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        alert.preferredAction = defaultAction
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showCustomAlert(title: String, actionTitle: String,message: String = "", onActionButton: @escaping EmptyCallback) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
                                onActionButton()
                            })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        alert.preferredAction = defaultAction
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension BaseViewController {
    open class func instance() -> Self {
        if let vc = createFromStoryboard(type: self) {
            return vc
        } else {
            print("WARNING: can't create view controller from storybard:\(self)")
            return self.init()
        }
    }
    
    private class func createFromStoryboard<T: UIViewController>(type: T.Type) -> T? {
        let storyboardName = String(describing: type)
        
        let bundle = Bundle(for: T.self)
        
        guard bundle.path(forResource: storyboardName, ofType: "storyboardc") != nil else {
            return nil
        }
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        guard let vc = storyboard.instantiateInitialViewController() else {
            print("no vc in storyboard(hint: check initial vc)"); return nil
        }
        
        return vc as? T
    }
}
