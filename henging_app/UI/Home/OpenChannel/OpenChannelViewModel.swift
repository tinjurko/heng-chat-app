//
//  OpenChannelViewModel.swift
//  henging_app
//
//  Created by Tin Jurkovic on 31.01.2022..
//

import UIKit
import SendBirdSDK
import Alamofire

class OpenChannelViewModel: BaseViewModel {
    var onGoToParticipantsScreen: ((SBDOpenChannel) -> Void)?
    var onRefreshMessages: ((Int) -> Void)?
    var onRecordingStateChanged: ((Bool) -> Void)? // isRecording
    var onRemainingRecordingTimeChanged: ((Int) -> Void)? // Recording remaining seconds
    var onUploadingFilePercentage: ((CGFloat) -> Void)? // Recording remaining seconds
    var onUploadingFileFinished: ((Bool) -> Void)? // isSuccess

    let limit = 200

    var audioRecorder: AudioRecorder? 
    var recordedAudioFileURL: URL?
    
    var openChannel: SBDOpenChannel!
    var messages: [SBDBaseMessage] = [] {
        didSet {
            onRefreshMessages?(messages.count)
        }
    }

    init(channel: SBDOpenChannel) {
        super.init()

        self.openChannel = channel
        enterTheChannel()

        SBDMain.add(self, identifier: Config.SendBird.uniqueDelegateID)
    }

    func getChannelImageURL() -> String {
        return openChannel.coverUrl ?? ""
    }

    func getChannelName() -> String {
        return openChannel.name
    }

    func getMessageCount() -> Int {
        return messages.count
    }

    func getMessage(index: Int) -> SBDBaseMessage {
        return messages[index]
    }

    func addMessage(message: SBDBaseMessage) {
        self.messages.append(message)
    }

    func goToParticipantsScreen() {
        onGoToParticipantsScreen?(openChannel)
    }

    // MARK: Audio Recording Methods
    func startAudioRecording() {
        audioRecorder = AudioRecorder()

        audioRecorder!.askPermission(completion: { isGranted in
            if !isGranted {
                DispatchQueue.main.async {
                    self.onError?("Manage your microphone permission in settings.")
                }

                return
            }

            self.configureAudioRecorderCallbacks()
            self.audioRecorder!.startRecording()
            self.onRecordingStateChanged?(true) //isRecording
        })
    }

    func stopAudioRecording() {
        if let audioRecorder = audioRecorder {
            audioRecorder.endRecording()
        }
    }

    func configureAudioRecorderCallbacks() {
        audioRecorder?.recorderDidFinish = { recorder, fileURL, isSuccess in
            self.onRecordingStateChanged?(false) //isRecording
            self.recordedAudioFileURL = fileURL
        }

        audioRecorder?.recorderOccurError = { recorder, error in
            self.onError?(error.localizedDescription)
        }

        audioRecorder?.onRecordingRemainingTime = { seconds in
            self.onRemainingRecordingTimeChanged?(seconds)
        }

        audioRecorder?.percentLoudness = { percentage in

        }
    }

    // MARK: SendBird Messaging Methods
    func enterTheChannel() {
        SBDOpenChannel.getWithUrl(openChannel.channelUrl) { openChannel, error in
            guard let openChannel = openChannel, error == nil else {
                self.onError?("Sorry. There is problem with channel configuration.")
                return
            }

            openChannel.enter { error in
                guard error == nil else {
                    return
                }

                self.openChannel = openChannel
                self.getChannelMessages()
            }
        }
    }

    func exitTheChannel() {
        guard let openChannel = openChannel else {
            return
        }

        openChannel.exitChannel { error in
            guard error == nil else {
                print("Problem with exiting channel")
                return
            }
        }
    }

    func getChannelMessages() {
        guard let openChannel = openChannel else {
            onError?("Sorry. There is problem with channel configuration.")
            return
        }

        // There should be only one single instance per channel. NOTE: CHECK GETBYTIMESTAMP METHOD
        let listQuery = openChannel.createPreviousMessageListQuery()

        Loading.shared.start()

        // Retrieving previous messages
        listQuery?.loadPreviousMessages(withLimit: limit, reverse: false, completionHandler: { (messages, error) in
            Loading.shared.stop()
            guard error == nil else {
                self.onError?("Sorry. There is problem with channel configuration.")
                return
            }

            self.messages.append(contentsOf: messages ?? [])
        })
    }

    func sendMessage(message: String, onComplete: EmptyCallback) {
        guard let openChannel = openChannel else {
            self.onError?("Sorry. There was problem with sending the messsage..")
            return
        }

        let preSendMessage = openChannel.sendUserMessage(message) { userMessage, error in
            guard let _ = userMessage, error == nil else {
                self.onError?("Sorry. There is problem with sending the message.")
                return
            }

            print("Message sent!")
        }

        self.messages.append(preSendMessage)
        SoundService.shared.playSound(sound: .sent)
        onComplete()
    }

    func sendAudioFile() {
        guard let audioFileURL = recordedAudioFileURL else {
            onError?("There was problem with recorded audio message!")
            return
        }

        guard let fileData = try? Data(contentsOf: audioFileURL) else {
            onError?("There was problem with recorded audio message!")
            return
        }
        let filename = audioFileURL.lastPathComponent
        let mimeType = "audio/mpeg"

        guard let params = SBDFileMessageParams(file: fileData) else {
            onError?("There was problem with sending audio message!")
            return
        }
        params.fileName = filename
        params.mimeType = mimeType
        params.fileSize = UInt(fileData.count)

        openChannel.sendFileMessage(with: params) { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            let progressPercentage = CGFloat(totalBytesSent) / CGFloat(totalBytesExpectedToSend)
            self.onUploadingFilePercentage?(progressPercentage*100)
            print(progressPercentage)
        } completionHandler: { fileMessage, error in
            if let error = error {
                self.onUploadingFileFinished?(false)
                self.onError?("There was problem with sending audio message!")
                print(error.localizedDescription)
                return
            }

            if let fileMessage = fileMessage {
                self.onUploadingFileFinished?(true)
                self.addMessage(message: fileMessage)
            }
        }
    }
}

extension OpenChannelViewModel: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        addMessage(message: message)
        SoundService.shared.playSound(sound: .recieved)
    }
}
