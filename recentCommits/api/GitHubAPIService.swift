//
//  GitHubAPIService.swift
//  recentCommits
//
//  Created by Isa Hashim on 2/17/21.
//

import Foundation

enum GitHubAPIErrors: Error {
    case urlCreationFailed
    case badHttpResponse(String)
    case noDataReturned
    case badHttpStatus(Int)
    case jsonParsingFailed(String)

    func getErrorString() -> String {
        switch self {
        case .urlCreationFailed:
            return "URL Creation failed"
        case .badHttpResponse(let errorString):
            return errorString
        case .noDataReturned:
            return "No data returned"
        case .badHttpStatus(let statusCode):
            return "Bad HTTP Status Code: \(statusCode)"
        case .jsonParsingFailed(let errorString):
            return "JSON Parsing failed: \(errorString)"
        }
    }
}

class GitHubAPIService {
    // API for list of commits:
    // https://api.github.com/repos/{owner}/{repo}/commits?per_page=25

    private let BASE_URL = "https://api.github.com"
    static let RecentCommitsPageSize = 25
    static let sharedInstance = GitHubAPIService()

    private init() {
    }

    func getCommits(forOwner owner: String, forRepo repo: String, pageSize: Int = RecentCommitsPageSize,
                    completion: ((Result<[Commit], GitHubAPIErrors>) -> Void)?) {

        guard let baseURL = URL(string: BASE_URL) else {
            completion?(.failure(GitHubAPIErrors.urlCreationFailed))
            return
        }

        // Use URL class to construct url without query params
        // Then use URLComponents to add query params

        let url = baseURL.appendingPathComponent("repos").appendingPathComponent(owner).appendingPathComponent(repo).appendingPathComponent("commits")

        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            completion?(.failure(GitHubAPIErrors.urlCreationFailed))
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: String(pageSize)),
            ]

        guard let urlWithParams = urlComponents.url else {
            completion?(.failure(GitHubAPIErrors.urlCreationFailed))
            return
        }

        print("URL: ", urlWithParams)

        URLSession.shared.dataTask(with: urlWithParams) { data, response, error in
            if let error = error {
                completion?(.failure(.badHttpResponse(error.localizedDescription)))
                return
            }
            guard let httpurlResponse = response as? HTTPURLResponse else {
                completion?(.failure(.badHttpResponse("Bad HTTP response")))
                return
            }

            guard httpurlResponse.statusCode == 200 else {
                completion?(.failure(.badHttpStatus(httpurlResponse.statusCode)))
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

    func getCommitsFromJSON(jsonData: Data) throws -> [Commit]? {
        let commits = try JSONDecoder().decode([Commit].self, from: jsonData)
        return commits
    }
}
