//
//  AppModel.swift
//  Subtasks
//
//  Created by david-swift on 23.04.23.
//

import ColibriComponents
import Foundation
import PigeonApp
import Realtime
import Supabase

/// The model that stores data that affects all of the windows.
@MainActor
class AppModel: ObservableObject {

    /// The shared instance of the AppModel.
    static var shared = AppModel()
    /// A list of all of the contributors.
    @Published var contributors: [(String, URL)] = []
    /// The tasks.
    @Published var tasks: [Subtask] = [] {
        didSet {
            if tasks != oldValue {
                UndoProvider.registerUndo(withTarget: self) { $0.tasks = oldValue }
            }
            if let data = try? JSONEncoder().encode(tasks) {
                UserDefaults.standard.set(data, forKey: .tasksID)
            }
        }
    }
    /// Whether the keyboard shortcut for navigation should be an arrow and command key or only an arrow key.
    @Published var useCommandForNavigation = false
    /// Whether the keyboard shortcut for deleting should be the delete and command key or only the delete key.
    @Published var useCommandForDeleting = false

    /// Important links.
    let links: [(LocalizedStringResource, URL)] = [
        (
            .init("GitHub", comment: "AppModel (Label of the link to the GitHub repository)"),
            .string(.gitHubRepo)
        ),
        (
            .init("Bug Report", comment: "AppModel (Label of the link to the bug report issue"),
            .string(.bugReport)
        ),
        (
            .init("Feature Request", comment: "AppModel (Label of the link to the feature request issue"),
            .string(.featureRequest)
        )
    ]

    // swiftlint:disable no_magic_numbers
    /// The app's versions.
    @ArrayBuilder<Version> var versions: [Version] {
        Version("0.1.3", date: .init(timeIntervalSince1970: 1_689_609_436)) {
            Version.Feature(.init(
                "Updated Settings Design",
                comment: "AppModel (Feature in version 0.1.3)"
            ), description: .init(
                "The buttons for adding and removing themes look more appealing.",
                comment: "AppModel (Feature in version 0.1.3)"
            ), icon: .paintbrush)
            Version.Feature(.init(
                "New _Updates_ and _About_ Windows",
                comment: "AppModel (Feature in version 0.1.3)"
            ), description: .init(
                "There are windows for _Subtasks > About Subtasks_ and _Subtasks > Updates_.",
                comment: "AppModel (Feature in version 0.1.3)"
            ), icon: .macwindow)
        }
        Version("0.1.2", date: .init(timeIntervalSince1970: 1_684_042_915)) {
            Version.Feature(.init(
                "Fixed Buggy Undo & Redo",
                comment: "AppModel (Feature in version 0.1.2)"
            ), description: .init(
                "*Edit > Undo* and *Edit > Redo* should now work.",
                comment: "AppModel (Description of feature in version 0.1.1)"
            ), icon: .arrowUturnBackward)
        }
        Version("0.1.1", date: .init(timeIntervalSince1970: 1_683_951_938)) {
            Version.Feature(.init(
                "Improved Synchronization",
                comment: "AppModel (Feature in version 0.1.1)"
            ), description: .init(
                "Get changes from the database that were made while the app was closed.",
                comment: "AppModel (Description of feature in version 0.1.1)"
            ), icon: .arrowTriangle2Circlepath)
        }
        Version("0.1.0", date: .init(timeIntervalSince1970: 1_683_448_596)) {
            Version.Feature(.init(
                "Initial Release",
                comment: "AppModel (Feature in version 0.1.0)"
            ), description: .init(
                "The first release of the Subtasks app.",
                comment: "AppModel (Description of feature in version 0.1.0)"
            ), icon: .partyPopper)
        }
    }
    // swiftlint:enable no_magic_numbers

    /// Initialize the ``AppModel``.
    init() {
        getContributors()
        getTasks()
    }

    /// Get the contributors from the Contributors.md file.
    private func getContributors() {
        let regex = /- \[(?<name>.+?)]\((?<link>.+?)\)/
        do {
            if let path = Bundle.main.path(forResource: "Contributors", ofType: "md") {
                let lines: [String] = try String(contentsOfFile: path).components(separatedBy: "\n")
                for line in lines where line.hasPrefix("- ") {
                    if let result = try? regex.wholeMatch(in: line), let url = URL(string: .init(result.output.link)) {
                        contributors.append((.init(result.output.name), url))
                    }
                }
            }
        } catch { }
    }

    /// Get the tasks from the disk.
    private func getTasks() {
        if let data = UserDefaults.standard.data(forKey: .tasksID),
           let tasks = try? JSONDecoder().decode([Subtask].self, from: data) {
            self.tasks = tasks
        }
    }

}
