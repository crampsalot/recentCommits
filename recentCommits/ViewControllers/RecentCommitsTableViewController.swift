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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let commit = commits[indexPath.row]

        if let tmpLabel = cell.viewWithTag(1) as? UILabel {
            tmpLabel.text = commit.commitDetails?.author.name
        }

        if let tmpLabel = cell.viewWithTag(2) as? UILabel {
            tmpLabel.text = commit.sha
        }

        if let tmpLabel = cell.viewWithTag(3) as? UILabel {
            tmpLabel.text = commit.commitDetails?.message
//            tmpLabel.text = "Really long line sdfd fdf dfdf sd fdf sdf fs df sdf sdf df sdf sdf sdf sdf sdf sd fsd fsdf sdf sdf sdfsd fsdf sf d"

        }

        return cell
    }

}
