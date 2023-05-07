//
//  TaskInformationView.swift
//  Subtasks
//
//  Created by david-swift on 27.04.23.
//

import ColibriComponents
import PigeonApp
import SwiftUI

/// A view letting the user edit information about the task.
struct TaskInformationView: View {

    /// The task.
    @Binding var task: Subtask
    /// The current theme.
    var theme: Theme

    /// The view's body.
    var body: some View {
        Form {
            Section {
                TaskRow(task: $task, theme: theme)
            }
            Section {
                Toggle(String(localized: .init(
                    "Completed",
                    comment: "TaskInformationView (Toggle for completion of task)"
                )), isOn: $task.isCompleted)
                TextField(
                    String(localized: .init(
                        "Title",
                        comment: "TaskInformationView (Text field for title of task)"
                    )),
                    text: $task.title,
                    axis: .vertical
                )
                TextField(
                    String(localized: .init(
                        "Description",
                        comment: "TaskInformationView (Text field for description of task)"
                    )),
                    text: $task.description,
                    axis: .vertical
                )
                Toggle(String(localized: .init(
                    "High Priority",
                    comment: "TaskInformationView (Toggle for priority of task)"
                )), isOn: $task.highPriority)
            }
        }
        .formStyle(.grouped)
    }

}
