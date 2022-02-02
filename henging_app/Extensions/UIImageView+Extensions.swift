//
//  UIImage+Extensions.swift
//
//  Created by Tin Jurković.
//  Copyright © 2020 Tin Jurković. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    class private var placeholderColor: UIColor? { return .lightGray }
    
    func loadImage(imageURL: String?, placeholderImage: UIImage? = nil) {
        guard let imageUrlString = imageURL?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: imageUrlString) else {
            DispatchQueue.main.async {
                if let placeholderImage = placeholderImage {
                    self.image = placeholderImage
                } else {
                    self.backgroundColor = UIImageView.placeholderColor
                }
            }
            return
        }
        
        retrieveImage(url: url, placeholderImage: placeholderImage, onComplete: nil)
    }
    
    func loadImage(imageURL: String?, imageView: UIImageView, placeholderImage: UIImage? = nil, onComplete: @escaping EmptyCallback) {
        guard let imageUrlString = imageURL, let url = URL(string: imageUrlString) else {
            DispatchQueue.main.async {
                if let placeholderImage = placeholderImage {
                    imageView.image = placeholderImage
                } else {
                    imageView.backgroundColor = UIImageView.placeholderColor
                }
            }
            return
        }
        
        retrieveImage(url: url, placeholderImage: placeholderImage) {
            onComplete()
        }
    }
    
    private func retrieveImage(url: URL, placeholderImage: UIImage? = nil, onComplete: EmptyCallback? = nil) {
        ImageCache.default.retrieveImage(forKey: url.absoluteString) { (result) in
            switch result {
            case .success(let value):
                if let image = value.image {
                    DispatchQueue.main.async {
                        self.image = image
                        self.backgroundColor = .clear
                        onComplete?()
                    }
                } else {
                    let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                    self.kf.setImage(with: resource, placeholder: placeholderImage, options: nil, progressBlock: nil) { (result) in
                        onComplete?()
                    }
                }

            case .failure(_):
                onComplete?()
                break
            }
        }
    }
}
