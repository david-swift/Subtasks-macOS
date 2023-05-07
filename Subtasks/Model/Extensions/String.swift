//
//  String.swift
//  Subtasks
//
//  Created by david-swift on 24.04.23.
//

import Foundation

extension String {

    /// The identifier of the tasks in the user defaults.
    static var tasksID: String { "tasks" }
    /// The identifier of the path in the user defaults.
    static var navigationID: String { "navigation" }
    /// The GitHub repository of the Subtasks app.
    static var gitHubRepo: String { "https://github.com/david-swift/Subtasks-macOS" }
    /// The URL to a new issue for a feature request.
    static var featureRequest: String {
        gitHubRepo
        + "/issues/new?assignees=&labels=enhancement&template=feature_request.yml"
    }
    /// The URL to a new issue for a bug report.
    static var bugReport: String {
        gitHubRepo
        + "/issues/new?assignees=&labels=bug&template=bug_report.yml"
    }
    /// The identifier of the Supabase URL in the user defaults.
    static var supabaseURLID: String { "supabaseURL" }
    /// The identifier of the Supabase key in the user defaults.
    static var supabaseKeyID: String { "supabaseKey" }
    /// The identifier of the Supabase row ID in the user defaults.
    static var supabaseRowID: String { "supabaseRow" }

    /// Convert a string into a task.
    /// The syntax is: `title @d:description @c:isCompleted @p:highPriority` where
    /// `description` is any text,
    /// `isCompleted` is either `true` or anything else and
    /// `highPriority` is either `high` or anything else.
    /// - Returns: The task.
    func getTask() -> Subtask {
        var task = Subtask(title: "")
        let array = self.components(separatedBy: " @")
        for keyValuePair in array {
            let keyValue = keyValuePair.split(separator: ":", maxSplits: 1)
            let key = keyValue[safe: 0] ?? ""
            var value = keyValue[safe: 1] ?? ""
            try? value.trimPrefix { $0 == " " }
            if value.isEmpty {
                task.title += key
            } else {
                switch key {
                case "d":
                    task.description += value
                case "c":
                    if value == "true" {
                        task.isCompleted = true
                    } else {
                        task.isCompleted = false
                    }
                case "p":
                    if value == "high" {
                        task.highPriority = true
                    } else {
                        task.highPriority = false
                    }
                default:
                    break
                }
            }
        }
        return task
    }

}
