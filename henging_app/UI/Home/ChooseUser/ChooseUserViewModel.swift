//
//  ChooseUserViewModel.swift
//  henging_app
//
//  Created by Tin Jurkovic on 30.01.2022..
//

import UIKit

class ChooseUserViewModel: BaseViewModel {
    var onUserChoosed: EmptyCallback?

    func chooseUser(user: LocalUser) {
        Loading.shared.start(backgroundAlpha: 1.0)
        
        APIManager.getUser(userID: user.id) { response in
            Loading.shared.stop()
            switch response {
            case .success(let data):
                UserService.shared.setUser(user: data)
                self.onUserChoosed?()
            case .failure(let error):
                self.onError?(error.getMessage())
            }
        }
    }
}
