//
//  ContentView.swift
//  Subtasks
//
//  Created by david-swift on 23.04.23.
//

import PigeonApp
import SFSafeSymbols
import SwiftUI

/// The main view of the app.
struct ContentView: View {

    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The model for one window.
    @StateObject private var viewModel = ViewModel()
    /// The active scheme.
    var theme: Theme

    /// The view's body.
    var body: some View {
        NavigationStack(path: .init {
            .init(viewModel.focusedTasks)
        } set: { newValue in
            if viewModel.focusedTasks.count > newValue.count {
                _ = viewModel.focusedTasks.popLast()
            }
        }) {
            TaskView(task: .init {
                var task = Subtask(id: .superTaskID)
                task.subtasks = appModel.tasks
                return task
            } set: { newValue in
                appModel.tasks = newValue.subtasks
            }, theme: theme)
            .navigationDestination(for: UUID.self) { id in
                TaskView(task: .init {
                    appModel.tasks.getTask(id: id) ?? .init(id: .superTaskID)
                } set: { newValue in
                    appModel.tasks.setTask(id: id, task: newValue)
                }, theme: theme)
            }
        }
        .environmentObject(viewModel)
        .focusedSceneObject(viewModel)
        .navigationTitle(LocalizedStringKey(stringLiteral: { () -> String in
            if let id = viewModel.focusedTasks.last, let task = appModel.tasks.getTask(id: id) {
                return task.title
            }
            return "Subtasks"
        }()))
        .frame(
            minWidth: .windowMinWidth,
            idealWidth: .windowIdealWidth,
            minHeight: .windowMinHeight,
            idealHeight: .windowIdealHeight
        )
        .toolbar(id: "toolbar") {
            SubtasksToolbar(viewModel: viewModel, theme: theme)
        }
    }

}
