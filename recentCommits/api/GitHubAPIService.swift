//
//  GitHubAPIService.swift
//  recentCommits
//
//  Created by Isa Hashim on 2/17/21.
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
    let sha: String?
    let commit: CommitDetails?
}

struct CommitDetails: Decodable {
    let author: Author?
    let message: String?
}

struct Author: Decodable {
    let name: String?
}

enum GitHubAPIErrors: Error {
    case urlCreationFailed
    case badHttpResponse
    case noDataReturned
    case badHttpStatus
    case jsonParsingFailed(String)
}

class GitHubAPIService {
    // API for list of commits:
    // https://api.github.com/repos/{owner}/{repo}/commits

    private let BASE_URL = "https://api.github.com"

    static let sharedInstance = GitHubAPIService()

    private init() {
    }

    func getCommits(forOwner owner: String, forRepo repo: String,
                    completion: ((Result<[Commit], GitHubAPIErrors>) -> Void)?) {

        guard let baseURL = URL(string: BASE_URL) else {
            completion?(.failure(GitHubAPIErrors.urlCreationFailed))
            return
        }

        let url = baseURL.appendingPathComponent("repos").appendingPathComponent(owner).appendingPathComponent(repo).appendingPathComponent("commits")

        print("URL: ", url)

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpurlResponse = response as? HTTPURLResponse else {
                completion?(.failure(.badHttpResponse))
                return
            }

            guard httpurlResponse.statusCode == 200 else {
                completion?(.failure(.badHttpStatus))
                return
            }

            guard let data = data else {
                completion?(.failure(.noDataReturned))
                return
            }

            do {
                if let commits = try self.getCommitsFromJSON(jsonData: data) {
                    completion?(.success(commits))
                }
            } catch let error as NSError {
                var errorString = "JSON parsing error: \(error)"
                if let jsonDataAsString = String(data: data, encoding: .utf8) {
                    errorString += "\nJSON: " + jsonDataAsString
                }
                completion?(.failure(.jsonParsingFailed(errorString)))
            }

            }.resume()
    }

    private func getCommitsFromJSON(jsonData: Data) throws -> [Commit]? {
        let commits = try JSONDecoder().decode([Commit].self, from: jsonData)
        return commits
    }

}
