//
//  RecentCommitTableViewCell.swift
//  recentCommits
//
//  Created by Isa Hashim on 2/21/21.
//

import UIKit

class RecentCommitTableViewCell: UITableViewCell {
    static let cellId = "RecentCommitTableViewCell"

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commitHashLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    func configure(viewModel: RecentCommitViewModel) {
        self.authorLabel.text = viewModel.author
        self.commitHashLabel.text = viewModel.commitHash
        self.messageLabel.text = viewModel.message
    }

}
