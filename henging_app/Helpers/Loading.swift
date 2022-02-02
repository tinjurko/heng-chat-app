//
//  Loading.swift
//  henging_app
//
//  Created by Tin Jurkovic on 02.02.2022..
//

import UIKit
import Lottie

class Loading: UIView {

    static let shared = Loading()

    var viewColor: UIColor = .white
    var setAlpha: CGFloat = 0.0
    var animationFile: String = "loading-square-orange-four"

    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
        transparentView.isUserInteractionEnabled = false
        return transparentView
    }()

    lazy var lottieView: AnimationView = {
        var lottieView = AnimationView(name: animationFile)
        lottieView.frame = .zero
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 1.5
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        return lottieView
    }()

    func start(_ vc: UIViewController? = nil, backgroundAlpha: CGFloat? = nil) {
        if let backgroundAlpha = backgroundAlpha {
            transparentView.backgroundColor = viewColor.withAlphaComponent(backgroundAlpha)
        } else {
            transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
        }

        self.addSubview(self.transparentView)
        self.transparentView.addSubview(self.lottieView)
        self.transparentView.bringSubviewToFront(self.lottieView)

        if let vc = vc {
            vc.view.addSubview(transparentView)
            setupConstraints()
            return
        }


        UIApplication.topViewController?.view.addSubview(transparentView)
        setupConstraints()
        lottieView.play()

    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            lottieView.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor),
            lottieView.centerXAnchor.constraint(equalTo: transparentView.centerXAnchor),
            lottieView.heightAnchor.constraint(equalToConstant: transparentView.frame.height * 0.10),
            lottieView.widthAnchor.constraint(equalToConstant: transparentView.frame.height * 0.10)
        ])
    }

    func stop() {
        self.transparentView.removeFromSuperview()
    }

}

