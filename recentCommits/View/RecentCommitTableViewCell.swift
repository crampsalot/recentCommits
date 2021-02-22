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

    func configure(model: Commit) {
        self.authorLabel.text = model.commitDetails?.author.name
        self.commitHashLabel.text = model.sha
        self.messageLabel.text = model.commitDetails?.message
    }

}
