//
//  recentCommitsTests.swift
//  recentCommitsTests
//
//  Created by Isa Hashim on 2/17/21.
//

import XCTest
@testable import recentCommits

class recentCommitsTests: XCTestCase {
    // MARK: - Tests for parsing/loading of JSON/Commit model object
    
    // Test to confirm commit count is zero when the JSON contains no commit objects
    func testZeroCommits() throws {
        guard let commits = getCommitsFromJSONFile(fileName: "zeroCommit") else {
            return
        }
        XCTAssertEqual(commits.count, 0)
    }
    
    // Tests there is just one commit in JSON and checks the properties
    func testOneCommit() throws {
        guard let commits = getCommitsFromJSONFile(fileName: "oneCommit") else {
            return
        }
        XCTAssertEqual(commits.count, 1)
        XCTAssertEqual(commits[0].sha, "COMMIT1_SHA")
        XCTAssertEqual(commits[0].commitDetails?.author?.name, "Isa Hashim")
        XCTAssertEqual(commits[0].commitDetails?.message, "Initial commit")
    }

    // Tests there is 14 commits in JSON and checks the properties of 7th commit
    func testMultipleA() throws {
        guard let commits = getCommitsFromJSONFile(fileName: "multipleA") else {
            return
        }
        XCTAssertEqual(commits.count, 14)
        let commit7 = commits[6]
        XCTAssertEqual(commit7.sha, "COMMIT7 SHA")
        XCTAssertEqual(commit7.commitDetails?.author?.name, "COMMIT7 Author")
        XCTAssertEqual(commit7.commitDetails?.message, "COMMIT7 Message")
    }

    // Tests JSON with bad key names. Checks that the properties of model are nil.
    func testBadNames() throws {
        guard let commits = getCommitsFromJSONFile(fileName: "badNames") else {
            return
        }
        XCTAssertEqual(commits.count, 1)
        XCTAssertNil(commits[0].sha)
        XCTAssertNil(commits[0].commitDetails?.author?.name)
        XCTAssertNil(commits[0].commitDetails?.message)
    }

    // MARK: - Tests for creation of view model object
    // Basic test to ensure the properties in view model match what is expected
    func testViewModel() throws {
        guard let commits = getCommitsFromJSONFile(fileName: "oneCommit") else {
            return
        }
        XCTAssertEqual(commits.count, 1)

        let model = RecentCommitViewModel(commit: commits[0])
        XCTAssertEqual(model.commitHash, "COMMIT1_SHA")
        XCTAssertEqual(model.author, "Isa Hashim")
        XCTAssertEqual(model.message, "Initial commit")
    }
    
    // Tests JSON with bad key names. Checks that the properties of view model are empty strings.
    func testBadNamesViewModel() throws {
        guard let commits = getCommitsFromJSONFile(fileName: "badNames") else {
            return
        }
        XCTAssertEqual(commits.count, 1)
       
        let model = RecentCommitViewModel(commit: commits[0])
        XCTAssertEqual(model.commitHash, "")
        XCTAssertEqual(model.author, "")
        XCTAssertEqual(model.message, "")

    }
    
    
    

    // MARK: - Utility functions

    private func getCommitsFromJSONFile(fileName: String) -> [Commit]? {
        if let jsonData = readLocalJSONFile(fileName: fileName) {
            do {
                if let commits = try GitHubAPIService.sharedInstance.getCommitsFromJSON(jsonData: jsonData) {
                    return commits
                }
            } catch let error as NSError {
                var errorString = "JSON parsing error: \(error)"
                if let jsonDataAsString = String(data: jsonData, encoding: .utf8) {
                    errorString += "\nJSON: " + jsonDataAsString
                }
                XCTFail(errorString)
            }
        }

        return nil
    }

    private func readLocalJSONFile(fileName: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            } else {
                XCTFail("File \(fileName) could not be loaded.")
            }
        } catch {
            XCTFail("File \(fileName) could not be loaded: \(error.localizedDescription)")
        }

        return nil
    }
}
