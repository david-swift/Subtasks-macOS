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
            UndoProvider.registerUndo(withTarget: self) { $0.tasks = oldValue }
            setTasks()
        }
    }
    /// Whether the last synchronization task succeeded and, if not, the error message.
    @Published var synchronizationSuccess: (Bool, String) = (false, .init())
    /// Whether the keyboard shortcut for navigation should be an arrow and command key or only an arrow key.
    @Published var useCommandForNavigation = false
    /// Whether the keyboard shortcut for deleting should be the delete and command key or only the delete key.
    @Published var useCommandForDeleting = false
    /// The URL to the Supabase database.
    @Published var supabaseURL: String = .init() {
        didSet {
            UserDefaults.standard.set(supabaseURL, forKey: .supabaseURLID)
            setTasks()
        }
    }
    /// The Supabase anonymous key.
    @Published var supabaseKey: String = .init() {
        didSet {
            UserDefaults.standard.set(supabaseKey, forKey: .supabaseKeyID)
            setTasks()
        }
    }
    /// The identifier of the active supabase row.
    @Published var supabaseRowID: Int = 0 {
        didSet {
            UserDefaults.standard.set(supabaseRowID, forKey: .supabaseRowID)
            setTasks()
        }
    }
    /// The Supabase client.
    private var client: SupabaseClient? {
        if let url = URL(string: supabaseURL) {
            return .init(supabaseURL: url, supabaseKey: supabaseKey)
        }
        synchronizationSuccess = (false, .init(localized: .init(
            "\"\(supabaseURL)\" is not a valid URL.",
            comment: "AppModel (String to URL conversion error)"
        )))
        return nil
    }

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
        getDatabaseInformation()
        getTasksFromDatabase()
    }

    /// A row in the Supabase database.
    private struct SupabaseType: Codable {

        /// The row's identifier.
        let id: Int
        /// The data.
        let data: String

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

    /// Get information about the database.
    private func getDatabaseInformation() {
        supabaseURL = UserDefaults.standard.string(forKey: .supabaseURLID) ?? .init()
        supabaseKey = UserDefaults.standard.string(forKey: .supabaseKeyID) ?? .init()
        supabaseRowID = UserDefaults.standard.integer(forKey: .supabaseRowID)
    }

    /// Update the tasks in the user defaults and the database.
    func setTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: .tasksID)
            if let client {
                let data = SupabaseType(id: supabaseRowID, data: .init(decoding: data, as: UTF8.self))
                let table = client.database.from(.tasksID)
                let updateQuery = table
                    .update(values: data)
                    .eq(column: "id", value: supabaseRowID)
                let insertQuery = table
                    .insert(values: data)
                Task {
                    do {
                        do {
                            try await updateQuery.execute()
                            try await insertQuery.execute()
                        } catch {
                            if !error.localizedDescription.hasSuffix("409.") {
                                throw error
                            }
                        }
                        synchronizationSuccess = (true, .init())
                    } catch {
                        synchronizationSuccess = (false, error.localizedDescription)
                    }
                }
            }
        } else {
            synchronizationSuccess = (false, .init(localized: .init(
                "The tasks could not be converted into data.",
                comment: "AppModel (Subtasks to data conversion error)"
            )))
        }
    }

    /// Get the tasks from the database.
    func getTasksFromDatabase() {
        if let client {
            let realtime = client.realtime
            let userChanges = realtime.channel(.table(.tasksID, schema: "public"))
            realtime.connect()
            userChanges.on(.all) { _ in
                let query = client.database
                    .from(.tasksID)
                    .select()
                Task {
                    do {
                        let response: [SupabaseType] = try await query.execute().value
                        if let string = response.first(where: { $0.id == self.supabaseRowID })?.data,
                        let data = string.data(using: .utf8) {
                            self.tasks = try JSONDecoder().decode([Subtask].self, from: data)
                        }
                    } catch {
                        self.synchronizationSuccess = (false, error.localizedDescription)
                    }
                }
            }
            userChanges.subscribe()
        }
    }

}
