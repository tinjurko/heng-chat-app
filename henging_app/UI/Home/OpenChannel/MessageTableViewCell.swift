//
//  MessageTableViewCell.swift
//  henging_app
//
//  Created by Tin Jurkovic on 01.02.2022..
//

import UIKit
import SendBirdSDK

class MessageTableViewCell: UITableViewCell {
    private var isAudioPlaying = false

    var onPlayAudioFile: ((String) -> Void)?
    var onStopAudioFile: EmptyCallback?

    private var fileURL: String?

    var message: SBDBaseMessage! {
        didSet {
            if let currentUser = SBDMain.getCurrentUser(), let senderUser = message.sender, currentUser.userId == senderUser.userId {
                currentUserView.isHidden = false
            } else {
                currentUserView.isHidden = true
            }

            // File Message Cell Configuration
            if let fileMessage = message as? SBDFileMessage {
                userImageView.loadImage(imageURL: fileMessage.sender?.profileUrl, placeholderImage: nil)
                nameLabel.text = fileMessage.sender?.nickname
                timeLabel.text = Date(timeIntervalSince1970: TimeInterval(fileMessage.createdAt) / 1000).toMessageFormatString()
                messageLabel.text = fileMessage.name

                fileURL = fileMessage.url

                if fileMessage.type == "audio/mpeg" {
                    showAudioFileLayout()
                } else {
                    hideAudioFileLayout()
                }

                return
            }

            // Message Cell Configuration
            userImageView.loadImage(imageURL: message.sender?.profileUrl, placeholderImage: nil)
            nameLabel.text = message.sender?.nickname
            timeLabel.text = Date(timeIntervalSince1970: TimeInterval(message.createdAt) / 1000).toMessageFormatString()
            messageLabel.text = message.message
        }
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var currentUserView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentMessageView: UIView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!

    // MARK: Constraints
    @IBOutlet weak var playImageView_Width: NSLayoutConstraint! //32
    @IBOutlet weak var messageLabel_Leading: NSLayoutConstraint! //+8
    @IBOutlet weak var messageLabel_Bottom: NSLayoutConstraint! //0
    @IBOutlet weak var messageLabel_CenterY_playImageView: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()

        configureLayout()
        hideAudioFileLayout()
        configureAudioPlayGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerFinished), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        currentUserView.isHidden = true
    }

    private func configureLayout() {
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.height/2
        userImageView.contentMode = .scaleAspectFit

        currentUserView.layer.cornerRadius = currentUserView.bounds.height/2
        currentUserView.backgroundColor = .blue

        nameLabel.font = Font.medium.size(14)
        nameLabel.textColor = .gray

        timeLabel.font = Font.regular.size(13)
        timeLabel.textColor = .greyMorgan

        playImageView.isUserInteractionEnabled = true
        playImageView.tintColor = .sendBirdPurple

        messageLabel.font = Font.regular.size(18)
        messageLabel.textColor = .black
    }

    private func configureAudioPlayGesture() {
        playImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(triggerAudio)))
    }

    @objc private func triggerAudio() {
        if isAudioPlaying {
            stopAudio()
            return
        }

        playAudio()
    }

    private func playAudio() {
        if let fileURL = fileURL {
            playImageView.image = UIImage(systemName: "stop.circle")
            onPlayAudioFile?(fileURL)
            isAudioPlaying = true
        }
    }

    private func stopAudio() {
        isAudioPlaying = false
        onStopAudioFile?()
        audioPlayerFinished()
    }

    @objc private func audioPlayerFinished() {
        playImageView.image = UIImage(systemName: "play.fill")
    }

    private func showAudioFileLayout() {
        playImageView_Width.constant = 32
        messageLabel_Leading.constant = 8
        messageLabel_Bottom.priority = UILayoutPriority(rawValue: 250)
        messageLabel_CenterY_playImageView.priority = UILayoutPriority(1000)
    }

    private func hideAudioFileLayout() {
        playImageView_Width.constant = 0
        messageLabel_Leading.constant = 0
        messageLabel_Bottom.priority = UILayoutPriority(rawValue: 1000)
        messageLabel_CenterY_playImageView.priority = UILayoutPriority(250)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        hideAudioFileLayout()
        currentUserView.isHidden = true
    }
}
