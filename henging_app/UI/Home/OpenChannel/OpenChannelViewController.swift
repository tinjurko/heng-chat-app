//
//  OpenChannelViewController.swift
//  henging_app
//
//  Created by Tin Jurkovic on 31.01.2022..
//

import UIKit
import AVKit
import ReverseExtension

class OpenChannelViewController: BaseViewController {
    var viewModel: OpenChannelViewModel!

    private var latestOriginY: CGFloat = 0
    var isAudioRecording = false
    var player: AVPlayer?
    var isGoingToParticipantsScreen = false

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputMessageView: UIView!
    @IBOutlet weak var messageInputTextField: UITextField!

    //AudioView
    @IBOutlet weak var audioContainerView: UIView!
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var audioDataLabel: UILabel!

    //SendView
    @IBOutlet weak var sendContainerView: UIView!
    @IBOutlet weak var sendImageView: UIImageView!

    // MARK: Constraint
    @IBOutlet weak var inputMessageView_Bottom: NSLayoutConstraint! //0
    @IBOutlet weak var messageInputTextField_Trailing: NSLayoutConstraint! //0
    @IBOutlet weak var sendContainerView_Width: NSLayoutConstraint! //60

    private let hiddenSendContainerView_Width: CGFloat = 16

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        configureCallbacks()
        configureNavigationBar()
        configureInputMessageView()
        configureTableView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        hideKeyboardIfNeeded = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAudio()

        if isGoingToParticipantsScreen {
            isGoingToParticipantsScreen = false
        } else {
            viewModel.exitTheChannel()
        }
    }

    private func configureCallbacks() {
        viewModel.onRefreshMessages = { [weak self] messagesCount in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.re.scrollToRow(at: IndexPath(row: messagesCount - 1, section: 0), at: .top, animated: true)
        }

        viewModel.onRecordingStateChanged = { [weak self] isRecording in
            guard let self = self else { return }
            self.isAudioRecording = isRecording

            if isRecording {
                DispatchQueue.main.async {
                    self.startRecordingAnimation()
                }
                return
            }

            DispatchQueue.main.async {
                self.stopRecordingAnimation()
                self.showSendAudioFileAlert()
            }
        }

        viewModel.onRemainingRecordingTimeChanged = { [weak self] seconds in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.audioDataLabel.text = "\(seconds) sec"
            }
        }

        viewModel.onUploadingFilePercentage = { [weak self] percentage in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.audioDataLabel.text = "\(Int(percentage))%"
            }
        }

        viewModel.onUploadingFileFinished = { [weak self] isSuccess in
            guard let self = self else { return }

            if isSuccess {
                self.audioDataLabel.text = "100%"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    self.hideAudioDataLabel()
                }
                return
            }

            self.hideAudioDataLabel()
        }

        viewModel.onError = { [weak self] message in
            guard let self = self else { return }
            self.showAlert(message: message)
        }
    }

    // MARK: Elements Configuration Methods
    private func configureInputMessageView() {
        audioImageView.tintColor = .sendBirdPurple
        sendImageView.tintColor = .sendBirdPurple

        audioDataLabel.font = Font.medium.size(12)
        audioDataLabel.textColor = .black

        messageInputTextField.backgroundColor = .greyDeal
        messageInputTextField.layer.cornerRadius = messageInputTextField.bounds.height/2
        messageInputTextField.addTarget(self, action: #selector(showHideSendButton), for: .editingChanged)
        messageInputTextField.contentInsets(left: 12, right: 12)
        messageInputTextField.tintColor = .sendBirdPurple
        messageInputTextField.font = Font.regular.size(18)

        hideSendButton()

        sendContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendTextMessage)))
        audioContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(triggerRecordingAction)))
    }

    private func configureNavigationBar() {
        let channelTopView = ChannelTopView()
        channelTopView.configureData(imageURL: viewModel.getChannelImageURL(), name: viewModel.getChannelName())

        let barButton = UIBarButtonItem(image: UIImage(systemName: "person.2.fill"), style: .plain, target: self, action: #selector(goToParticipantsScreen))
        barButton.tintColor = .sendBirdPurple

        self.navigationItem.titleView = channelTopView
        self.navigationItem.rightBarButtonItem = barButton
    }

    private func configureTableView() {
        tableView.re.delegate = self
        tableView.re.dataSource = self

        tableView.re.scrollViewDidReachBottom = { scrollView in
            //did reach bottom
        }

        tableView.re.scrollViewDidReachTop = { scrollView in
            //did reach top
        }

        tableView.keyboardDismissMode = .onDrag

        tableView.register(cellClass: MessageTableViewCell.self)
    }

    // MARK: Coordinator Methods
    @objc private func goToParticipantsScreen() {
        viewModel.goToParticipantsScreen()
        isGoingToParticipantsScreen = true
    }

    // MARK: Send Button Methods
    @objc private func showHideSendButton() {
        let charCount = messageInputTextField.text?.count ?? 0
        if charCount > 0 {
            showSendButton()
            return
        }

        hideSendButton()
    }

    private func hideSendButton() {
        sendContainerView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.sendContainerView_Width.constant = self.hiddenSendContainerView_Width
            self.sendImageView.alpha = 0

            self.inputMessageView.layoutIfNeeded()
        }
    }

    private func showSendButton() {
        sendContainerView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.sendContainerView_Width.constant = 60
            self.sendImageView.alpha = 1

            self.inputMessageView.layoutIfNeeded()
        }
    }

    @objc private func sendTextMessage() {
        if let text = messageInputTextField.text {
            viewModel.sendMessage(message: text) {
                self.messageInputTextField.text = ""
                hideSendButton()
            }
        }
    }

    // MARK: Audio Recording Methods
    @objc func triggerRecordingAction() {
        if isAudioRecording {
            viewModel.stopAudioRecording()
            return
        }

        viewModel.startAudioRecording()
    }

    private func startRecordingAnimation() {
        showAudioDataLabel()

        audioImageView.image = UIImage(systemName: "record.circle")
        audioImageView.tintColor = .red
        audioImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: CGFloat(0.15), initialSpringVelocity: CGFloat(4.0), options: [.allowUserInteraction, .repeat, .autoreverse]) {
            self.audioImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        } completion: { isCompleted in }
    }

    private func stopRecordingAnimation() {
        hideAudioDataLabel()

        audioImageView.layer.removeAllAnimations()
        audioImageView.transform = CGAffineTransform.identity
        audioImageView.image = UIImage(systemName: "mic.fill")
        audioImageView.tintColor = .sendBirdPurple
    }

    private func showSendAudioFileAlert() {
        self.showCustomAlert(title: "Do you want to send recorded audio file?", actionTitle: "Send") {
            self.viewModel.sendAudioFile()
            self.showAudioDataLabel(with: "0%")
        }
    }

    private func showAudioDataLabel(with string: String? = nil) {
        if let string = string {
            audioDataLabel.text = string
        }

        UIView.animate(withDuration: 0.3) {
            self.messageInputTextField_Trailing.constant = 12
            self.inputMessageView.layoutIfNeeded()
        }
    }

    private func hideAudioDataLabel() {
        audioDataLabel.text = ""

        UIView.animate(withDuration: 0.3) {
            self.messageInputTextField_Trailing.constant = 0
            self.inputMessageView.layoutIfNeeded()
        }
    }

    // MARK: Message Input View Methods for Tracking Keyboard

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let rawKeyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardSize = getActualKeyboardHeight(keyboardHeight: rawKeyboardSize.height)
        self.inputMessageView_Bottom.constant = -keyboardSize
        self.view.layoutIfNeeded()
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.inputMessageView_Bottom.constant = 0
        self.view.layoutIfNeeded()
    }

    private func getActualKeyboardHeight(keyboardHeight: CGFloat) -> CGFloat {
        let bottomInset = view.safeAreaInsets.bottom
        return keyboardHeight - bottomInset
    }

    // MARK: Play Audio Methods
    private func playAudio(url: String) {
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        self.player = AVPlayer(playerItem:playerItem)
        player!.volume = 1.0
        player!.play()
    }

    private func stopAudio() {
        self.player = nil
    }
}

extension OpenChannelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMessageCount()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(for: MessageTableViewCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }

        cell.message = viewModel.getMessage(index: indexPath.row)

        cell.onPlayAudioFile = { url in
            self.playAudio(url: url)
        }

        cell.onStopAudioFile = {
            self.stopAudio()
        }

        return cell
    }
}

