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
        author = commit.commitDetails?.author.name ?? ""
        commitHash = commit.sha ?? ""
        message = commit.commitDetails?.message ?? ""
    }
}
