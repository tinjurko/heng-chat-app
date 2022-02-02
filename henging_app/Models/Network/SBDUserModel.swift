//
//  SBDAccessTokenModel.swift
//  henging_app
//
//  Created by Tin Jurkovic on 02.02.2022..
//

import Foundation

class SBDUserModel: Codable {
    let userID: String
    let nickname: String
    let unreadMessageCount: Int?
    let profileURL: String?
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname
        case unreadMessageCount = "unread_message_count"
        case profileURL = "profile_url"
        case accessToken = "access_token"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userID = try container.decode(String.self, forKey: .userID)
        nickname = try container.decode(String.self, forKey: .nickname)
        unreadMessageCount = try container.decodeIfPresent(Int.self, forKey: .unreadMessageCount)
        profileURL = try container.decodeIfPresent(String.self, forKey: .profileURL)
        accessToken = try container.decode(String.self, forKey: .accessToken)
    }
}

