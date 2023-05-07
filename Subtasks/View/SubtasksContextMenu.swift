//
//  SubtasksContextMenu.swift
//  Subtasks
//
//  Created by david-swift on 01.05.23.
//

import SwiftUI

/// The context menu of a task.
struct SubtasksContextMenu: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The task.
    @Binding var task: Subtask

    /// The view's body.
    var body: some View {
        Toggle(String(localized: .init(
            "Completed",
            comment: "SubtasksContextMenu (Completed toggle in context menu)"
        )), isOn: $task.isCompleted)
        Toggle(String(localized: .init(
            "High Priority",
            comment: "SubtasksContextMenu (High priority toggle in context menu)"
        )), isOn: $task.highPriority)
        Divider()
        Button(.init("Show Subtasks", comment: "SubtasksContextMenu (Show subtasks button in context menu)")) {
            viewModel.showSubtasks()
        }
        Button(.init("Show Information", comment: "SubtasksContextMenu (Show information button in context menu)")) {
            viewModel.information = true
        }
        Divider()
        Button(.init("Delete", comment: "SubtasksContextMenu (Delete button in context menu)"), role: .destructive) {
            viewModel.deleteTask()
        }
    }

}

/// Previews for the ``SubtasksContextMenu``.
struct SubtasksContextMenu_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        SubtasksContextMenu(task: .constant(.init()))
    }

}
