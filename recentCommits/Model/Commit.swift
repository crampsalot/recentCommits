//
//  Commit.swift
//  recentCommits
//
//  Created by Isa Hashim on 2/21/21.
//

import Foundation

// Each commit is represented by the following in JSON:
//   {
//      "sha": "6ae62701c348a37d5531a2a5e1b3f1cad3d52961"
//      ...
//      "commit": {
//          "author": {
//              "name": "Isa Hashim",
//              ...
//          },
//          "message": "Initial xcode project.",
//          ...
//      }
//   }
//
struct Commit: Decodable {
    // Within the commit JSON object, there is a 'commit'
    // property which is an object containing more detail.
    // The model object will capture this as 'commitDetails' to
    // avoid any confusion and the CodingKeys enum keys is added
    // to ensure parsing still works.
    private enum CodingKeys: String, CodingKey {
        case sha
        case commitDetails = "commit"
    }

    let sha: String?
    let commitDetails: CommitDetails?
}

struct CommitDetails: Decodable {
    let author: Author?
    let message: String?
}

struct Author: Decodable {
    let name: String?
}
