//
//  TaskView.swift
//  Subtasks
//
//  Created by david-swift on 26.04.23.
//

import PigeonApp
import SwiftUI

/// The list of subtasks of a task.
@MainActor
struct TaskView: View {

    /// The view model.
    @EnvironmentObject private var viewModel: ViewModel
    /// The app model.
    @EnvironmentObject private var appModel: AppModel
    /// The parent task.
    @Binding var task: Subtask
    /// The current theme.
    var theme: Theme

    /// The view's body.
    var body: some View {
        List(Array($task.subtasks.enumerated()), id: \.element.id) { index, $task in
            TaskRow(task: $task, theme: theme)
                .padding(.taskRowPadding)
                .listRowBackground(
                    (task.highPriorityChild ? theme.secondaryAccent : Color.gray)
                        .opacity(.listRowBackgroundOpacity)
                        .cornerRadius(.colibriCornerRadius)
                        .padding(.listRowBackgroundPadding)
                        .padding(.horizontal, .listRowBackgroundPadding)
                        .opacity(viewModel.selection == index ? 1 : 0)
                )
                .onHover { if $0 && !viewModel.information { viewModel.selection = index } }
                .onTapGesture { _ in
                    viewModel.focusedTasks.append(task.id)
                }
                .accessibilityAddTraits(.isButton)
                .contextMenu {
                    SubtasksContextMenu(task: $task)
                }
                .sheet(isPresented: (
                    viewModel.information && viewModel.getSelectedTask()?.id == task.id
                ).binding { newValue in
                    if !newValue { viewModel.information = false }
                }) {
                    TaskInformationView(task: $task, theme: theme)
                        .frame(width: .taskInformationSheetWidth, height: .taskInformationSheetHeight)
                }
        }
        .animation(.default.speed(.taskAnimationSpeed), value: task.subtasks)
    }

}
