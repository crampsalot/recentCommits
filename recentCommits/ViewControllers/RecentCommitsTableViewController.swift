//
//  RecentCommitsTableViewController.swift
//  recentCommits
//
//  Created by Isa Hashim on 2/19/21.
//

import UIKit

class RecentCommitsTableViewController: UITableViewController {
    private var commits: [Commit] = []
    private let cellId = "cellId"

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.title = "Recent Commits"
        fetchCommits()
    }

    // MARK: - Load data
    private func fetchCommits() {
        GitHubAPIService.sharedInstance.getCommits(forOwner: "crampsalot", forRepo: "recentCommits") { result in
            switch (result) {
            case .success(let commits):
                self.commits = commits
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
        return commits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentCommitTableViewCell.cellId, for: indexPath) as? RecentCommitTableViewCell else {
            return UITableViewCell()
        }

        let commit = commits[indexPath.row]
        cell.configure(model: commit)

        return cell
    }

}
