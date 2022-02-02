//
//  UserService.swift
//  henging_app
//
//  Created by Tin Jurkovic on 31.01.2022..
//

import Foundation

class UserService {
    private var user: SBDUserModel?

    static let shared = UserService()

    func setUser(user: SBDUserModel) {
        self.user = user
    }

    func getUser() -> SBDUserModel? {
        return user
    }
}
