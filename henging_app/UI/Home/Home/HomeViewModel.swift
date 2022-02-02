//
//  HomeViewModel.swift
//  my-dubrovnik-ios
//
//  Created by Tin Jurković on 28/1/2022.
//  Copyright © 2022 Tin Jurković. All rights reserved.
//

import UIKit
import SendBirdSDK

class HomeViewModel: BaseViewModel {
    var openChannel: SBDOpenChannel? = nil

    var openChannels: [SBDOpenChannel] = []

    var onGoToChannel: ((SBDOpenChannel) -> Void)?
    var onChannelsLoaded: EmptyCallback?

    var user: SBDUserModel!

    override init() {
        super.init()

        guard let user = UserService.shared.getUser() else {
            self.onError?("User not choosed!")
            return
        }

        self.user = user

        connectToSendBirdServer()
    }

    func getTitle() -> String {
        if let name = UserService.shared.getUser()?.nickname {
            let title = "\(String(describing: name))'s Chat"
            return title
        }

        return "Chat"
    }

    func goToChannel(channel: SBDOpenChannel) {
        onGoToChannel?(channel)
    }

    func getChannelCount() -> Int {
        return openChannels.count
    }

    func getChannel(index: Int) -> SBDOpenChannel {
        return openChannels[index]
    }

    func connectToSendBirdServer() {
        Loading.shared.start()
        SBDMain.connect(withUserId: user.userID, accessToken: user.accessToken) { user, error in
            guard let _ = user, error == nil else {
                Loading.shared.stop()
                self.onError?("There was problem with connecting to our Servers!")
                return
            }


            self.getChannels()
        }
    }

    func getChannels() {
        let listQuery = SBDOpenChannel.createOpenChannelListQuery()

        listQuery?.loadNextPage(completionHandler: { fetchedOpenChannels, error in
            Loading.shared.stop()
            guard error == nil else {
                self.onError?("There was an error while fetching chats!")
                return
            }

            self.openChannels.append(contentsOf: fetchedOpenChannels ?? [])
            self.onChannelsLoaded?()
        })
    }


    //Pick user and create channel with him
    func createChannel() {
        let params = SBDOpenChannelParams()
        SBDOpenChannel.createChannel(with: params) { channel, error in
                guard let _ = channel, error == nil else {
                        return // Handle error.
                }

                // An open channel is successfully created.
                // Through the "openChannel" parameter of the callback method,
                // you can get the open channel's data from the Sendbird server.

        }
    }

}
