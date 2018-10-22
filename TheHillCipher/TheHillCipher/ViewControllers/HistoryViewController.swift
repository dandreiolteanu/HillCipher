//
//  HistoryViewController.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 22/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private Properties

    private let userDefaultsManager = UserDefaultsManager.shared
    private lazy var history: [History] = userDefaultsManager.history.reversed()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
    }
}

// MARK: - UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }

        cell.configureCell(with: history[indexPath.item])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        history.remove(at: indexPath.row)
        userDefaultsManager.history = self.history

        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
