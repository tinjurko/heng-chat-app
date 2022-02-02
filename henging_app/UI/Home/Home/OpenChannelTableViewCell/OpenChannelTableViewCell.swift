//
//  OpenChannelTableViewCell.swift
//  henging_app
//
//  Created by Tin Jurkovic on 31.01.2022..
//

import UIKit
import SendBirdSDK

class OpenChannelTableViewCell: UITableViewCell {

    var channel: SBDOpenChannel! {
        didSet {
            channelImageView.loadImage(imageURL: channel.coverUrl, placeholderImage: nil)

            channelNameLabel.text = channel.name

            let numberOfPart = channel.participantCount
            let string = numberOfPart == 1 ? "\(numberOfPart) Participant" : "\(numberOfPart) Participants"
            channelParticipantsLabel.text = string
        }
    }

    var onChannelTouchUpInside: ((SBDOpenChannel) -> Void)?

    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var channelParticipantsLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        configureLayout()
        configureTapGesture()
    }

    func configureLayout() {
        channelImageView.clipsToBounds = true
        channelImageView.contentMode = .scaleAspectFill
        channelImageView.layer.cornerRadius = channelImageView.bounds.width/2

        channelNameLabel.font = Font.medium.size(17)
        channelNameLabel.textColor = .black

        channelParticipantsLabel.font = Font.regular.size(12)
        channelParticipantsLabel.textColor = .greyMorgan

        separatorView.backgroundColor = .greyDeal
    }

    func configureTapGesture() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture)))
    }

    @objc func tapGesture() {
        onChannelTouchUpInside?(channel)
    }
}
