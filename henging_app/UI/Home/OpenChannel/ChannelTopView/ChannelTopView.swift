//
//  ChannelTopView.swift
//  henging_app
//
//  Created by Tin Jurkovic on 01.02.2022..
//

import UIKit

class ChannelTopView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var channelImageView: UIImageView!
    @IBOutlet var channelNameLabel: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle(for: ChannelTopView.self).loadNibNamed("ChannelTopView", owner: self, options: nil)
        addSubview(view)

        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setNeedsLayout()

        configureLayout()
    }

    func configureLayout() {
        channelImageView.clipsToBounds = true
        channelImageView.contentMode = .scaleAspectFill
        channelImageView.layer.cornerRadius = channelImageView.bounds.width/2

        channelNameLabel.font = Font.medium.size(15)
        channelNameLabel.textColor = .black
    }

    func configureData(imageURL: String, name: String) {
        channelImageView.loadImage(imageURL: imageURL, placeholderImage: nil)
        channelNameLabel.text = name
        setNeedsLayout()
    }
}
