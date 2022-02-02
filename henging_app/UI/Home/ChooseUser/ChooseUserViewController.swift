//
//  ChooseUserViewController.swift
//  henging_app
//
//  Created by Tin Jurkovic on 30.01.2022..
//

import UIKit

class ChooseUserViewController: BaseViewController {
    var viewModel: ChooseUserViewModel!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var btnUser01: UIButton!
    @IBOutlet weak var user01ImageView: UIImageView!
    @IBOutlet weak var user01Label: UILabel!

    @IBOutlet weak var btnUser02: UIButton!
    @IBOutlet weak var user02ImageView: UIImageView!
    @IBOutlet weak var user02Label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureUserData()
        configureGestureRecognizers()

        configureCallbacks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        invisibleNavigationBar()
    }

    func configureCallbacks() {
        viewModel.onError = { [weak self] error in
            guard let self = self else { return }
            self.showAlert(message: error)
        }
    }

    func configureLayout() {
        user01ImageView.contentMode = .scaleAspectFill

        user01Label.font = Font.medium.size(20)
        user01Label.textColor = .black

        user02ImageView.contentMode = .scaleAspectFill

        user02Label.font = Font.medium.size(20)
        user02Label.textColor = .black
    }

    func configureUserData() {
        user01ImageView.image = Config.LocalUsers.user01.image
        user01Label.text = Config.LocalUsers.user01.name

        user02ImageView.image = Config.LocalUsers.user02.image
        user02Label.text = Config.LocalUsers.user02.name
    }

    func configureGestureRecognizers() {
        btnUser01.addTarget(self, action: #selector(tapGesture(button:)), for: .touchUpInside)
        btnUser02.addTarget(self, action: #selector(tapGesture(button:)), for: .touchUpInside)
    }

    @objc func tapGesture(button: UIButton) {
        switch button {
        case btnUser01:
            viewModel.chooseUser(user: Config.LocalUsers.user01)
        case btnUser02:
            viewModel.chooseUser(user: Config.LocalUsers.user02)
        default:
            break
        }
    }
}
