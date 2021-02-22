//
//  RecentCommitsTableViewController.swift
//  recentCommits
//
//  Created by Isa Hashim on 2/19/21.
//

import UIKit

class RecentCommitsTableViewController: UITableViewController {
    private var commitViewModels: [RecentCommitViewModel] = []

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recent Commits"
        fetchCommits()
    }

    // MARK: - Load data
    private func fetchCommits() {
        GitHubAPIService.sharedInstance.getCommits(forOwner: "crampsalot", forRepo: "recentCommits") { result in
            switch (result) {
            case .success(let commits):
                self.commitViewModels = commits.map({ return RecentCommitViewModel(commit: $0)})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                print("Failed to get commits")
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentCommitTableViewCell.cellId, for: indexPath) as? RecentCommitTableViewCell else {
            return UITableViewCell()
        }

        let commitViewModel = commitViewModels[indexPath.row]
        cell.configure(viewModel: commitViewModel)

        return cell
    }

}
