//
//  UICollectionView+Extensions.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: .main), forCellWithReuseIdentifier: String(describing: cell))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for cell: T.Type, indexPath: IndexPath) -> T? {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: cell), for: indexPath) as? T else {
            return nil
        }
        
        return cell
    }
}
