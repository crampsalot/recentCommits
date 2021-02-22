//
//  RecentCommitViewModel.swift
//  recentCommits
//
//  Created by Isa Hashim on 2/21/21.
//

import Foundation

struct RecentCommitViewModel {
    let author: String
    let commitHash: String
    let message: String

    init(commit: Commit) {
        self.author = commit.commitDetails?.author?.name ?? ""
        self.commitHash = commit.sha ?? ""
        self.message = commit.commitDetails?.message ?? ""
    }
}
