//
//  SubtasksApp.swift
//  Subtasks
//
//  Created by david-swift on 23.04.23.
//

import ColibriComponents
import PigeonApp
import SettingsKit
import SwiftUI

/// The main app.
@main
struct SubtasksApp: App {

    /// The shared instance of the app model.
    @StateObject private var appModel = AppModel.shared

    /// The view's body.
    var body: some Scene {
        PigeonApp(appName: "Subtasks", appIcon: .init(nsImage: .init(named: "AppIcon") ?? .init())) { _, theme, _ in
            ContentView(theme: theme)
                .environmentObject(appModel)
        }
        .information(description: .init(localized: .init(
            "A native macOS app for organizing your tasks.",
            comment: "SubtasksApp (The app's description)"
        ))) {
            for link in appModel.links {
                (.init(localized: link.0), link.1)
            }
        } contributors: {
            for contributor in appModel.contributors {
                contributor
            }
        } acknowledgements: {
            ("Supabase", .string("https://github.com/supabase-community/supabase-swift"))
            ("SwiftLintPlugin", .string("https://github.com/lukepistrol/SwiftLintPlugin"))
            ("PigeonApp", .string("https://github.com/david-swift/PigeonApp-macOS"))
        }
        .extendShortcutsView {
            Section(.init("Command Key", comment: "SubtasksApp (Command key extension of shortcuts settings)")) {
                Toggle(isOn: $appModel.useCommandForNavigation) {
                    Text(.init(
                        "Use Command Key for Navigation",
                        comment: "SubtasksApp (Title of command for navigation option)"
                    ))
                    Text(.init(
                        "If activated, use ⌘􀰁 and ⌘􀄧 for navigation, otherwise, use 􀰁 and 􀄧.",
                        comment: "SubtasksApp (Description of command for navigation option)"
                    ))
                }
                Toggle(isOn: $appModel.useCommandForDeleting) {
                    Text(.init(
                        "Use Command Key for Deletion",
                        comment: "SubtasksApp (Title of command for deletion option)"
                    ))
                    Text(.init(
                        "If activated, use ⌘⌫ for deleting, otherwise, use ⌫.",
                        comment: "SubtasksApp (Description of command for navigation option)"
                    ))
                }
            }
        }
        .help(.init(
            "Subtasks Help",
            comment: "SubtasksApp (Label of the help link)"
        ), link: .string("https://david-swift.gitbook.io/subtasks/"))
        .pigeonSettings {
            SettingsTab(.init(.init(
                "Synchronization",
                comment: "SubtasksApp (Synchronization settings tab)"
            ), systemSymbol: .arrowTriangle2Circlepath), id: "synchronization") {
                SettingsSubtab(.noSelection, id: "synchronization") {
                    SynchronizationSettings()
                        .environmentObject(appModel)
                }
            }
        }
        .themes { theme in
            ThemesPreview(theme: theme)
        }
        .newestVersion(gitHubUser: "david-swift", gitHubRepo: "Subtasks-macOS")
        .versions {
            for version in appModel.versions { version }
        }
        .keyboardShortcut(.init("n", modifiers: [.shift, .command]))
        .commands {
            SubtasksCommands()
        }
    }

}
