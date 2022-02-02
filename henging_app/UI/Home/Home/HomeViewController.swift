//
//  HomeViewController.swift
//  my-dubrovnik-ios
//
//  Created by Tin Jurković on 28/11/2019.
//  Copyright © 2019 Tin Jurković. All rights reserved.
//

import UIKit
import SendBirdSDK

class HomeViewController: BaseViewController {
    var viewModel: HomeViewModel!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCallbacks()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = viewModel.getTitle()
    }

    func configureCallbacks() {
        viewModel.onChannelsLoaded = { [weak self] in
            guard let self = self else { return }

            self.tableView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            guard let self = self else { return }
            self.showTitleAlert(title: "Oops!", message: message)
        }
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(cellClass: OpenChannelTableViewCell.self)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getChannelCount()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(for: OpenChannelTableViewCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }

        cell.channel = viewModel.getChannel(index: indexPath.row)

        cell.onChannelTouchUpInside = { channel in
            self.viewModel.goToChannel(channel: channel)
        }

        return cell
    }
}
