//
//  HomeCoordinator.swift
//  my-dubrovnik-ios
//
//  Created by Tin Jurković on 28/11/2019.
//  Copyright © 2019 Tin Jurković. All rights reserved.
//

import UIKit
import SendBirdUIKit

class HomeCoordinator: Coordinator {
    private var childCoordinators: [Coordinator] = []
    private var rootCoordinator: Coordinator?
    private var navigationController = BaseNavigationController()
    
    func start() -> UIViewController {
        let vc = self.createChooseUserViewController()
        navigationController.viewControllers = [vc]

        navigationController.showAsRoot()

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.rootCoordinator = self
        }

        return navigationController
    }

    func createChooseUserViewController() -> UIViewController {
        let viewcontroller = ChooseUserViewController.instance()
        let viewmodel = ChooseUserViewModel()

        viewcontroller.viewModel = viewmodel

        viewmodel.onUserChoosed = { [weak self] in
            guard let self = self else { return }
            self.navigationController.pushViewController(self.createHomeViewController(), animated: true)
        }

        return viewcontroller
    }

    func createHomeViewController() -> UIViewController {
        let viewcontroller = HomeViewController.instance()
        let viewmodel = HomeViewModel()
        
        viewcontroller.viewModel = viewmodel

        viewmodel.onGoToChannel = { [weak self] channel in
            guard let self = self else { return }

            self.navigationController.pushViewController(self.createOpenChannelViewController(channel: channel), animated: true)
        }
        
        return viewcontroller
    }

    func createOpenChannelViewController(channel: SBDOpenChannel) -> UIViewController {
        let viewcontroller = OpenChannelViewController.instance()
        let viewmodel = OpenChannelViewModel(channel: channel)

        viewcontroller.viewModel = viewmodel

        viewmodel.onGoToParticipantsScreen = { [weak self] channel in
            guard let self = self else { return }
            self.navigationController.pushViewController(self.createSBUMemberListViewController(channel: channel), animated: true)
        }

        return viewcontroller
    }

    func createSBUMemberListViewController(channel: SBDOpenChannel) -> UIViewController {
        let viewcontroller = SBUMemberListViewController(channel: channel, type: .participants)

        return viewcontroller
    }
    
}
