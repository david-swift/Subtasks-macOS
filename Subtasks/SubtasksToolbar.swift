//
//  SubtasksToolbar.swift
//  Subtasks
//
//  Created by david-swift on 01.05.23.
//

import PigeonApp
import SwiftUI

/// The main window's toolbar.
struct SubtasksToolbar: CustomizableToolbarContent {

    /// The view model.
    @ObservedObject var viewModel: ViewModel
    /// The active theme.
    var theme: Theme

    /// The view's body.
    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "information") {
            Button {
                viewModel.information.toggle()
            } label: {
                Label(.init(
                    "Information",
                    comment: "SubtasksToolbar (Button for toggling information visibility)"
                ), systemSymbol: .info)
            }
        }
        .defaultCustomization(.hidden)
        ToolbarItem(id: "delete") {
            Button {
                viewModel.deleteTask()
            } label: {
                Label(.init(
                    "Delete Task",
                    comment: "SubtasksToolbar (Button for deleting the task)"
                ), systemSymbol: .trash)
            }
        }
        .defaultCustomization(.hidden)
        ToolbarItem(id: "high-priority") {
            Toggle(isOn: $viewModel.highPriority) {
                Label(.init(
                    "High Priority",
                    comment: "SubtasksToolbar (Button for changing the priority of the task)"
                ), systemSymbol: .exclamationmark)
            }
        }
        .defaultCustomization(.hidden)
        ToolbarItem(id: "completed") {
            Toggle(isOn: $viewModel.completed) {
                Label(.init(
                    "Completed",
                    comment: "SubtasksToolbar (Button for changing the completion of the task)"
                ), systemSymbol: .checkmark)
            }
        }
        .defaultCustomization(.hidden)
        ToolbarItem(id: "show-subtasks") {
            Button {
                viewModel.showSubtasks()
            } label: {
                Label(.init(
                    "Show Subtasks",
                    comment: "SubtasksToolbar (Button for showing the task's subtasks)"
                ), systemSymbol: .circleInsetFilled)
            }
        }
        .defaultCustomization(.hidden)
        ToolbarItem(id: "add-task") {
            Button {
                viewModel.addTask()
            } label: {
                Label(.init(
                    "Add Task",
                    comment: "SubtasksToolbar (Button for adding a task)"
                ), systemSymbol: .plus)
            }
            .popover(isPresented: $viewModel.addPopover, arrowEdge: .bottom) {
                createTaskField
            }
        }
        .customizationBehavior(.disabled)
        .defaultCustomization(options: .alwaysAvailable)
    }

    /// The popover for creating a task.
    private var createTaskField: some View {
        VStack {
            TextField(String("Create Task"), text: $viewModel.addText)
                .textFieldStyle(.roundedBorder)
                .frame(width: .createTaskFieldWidth)
                .onSubmit {
                    viewModel.addTask(task: viewModel.addText.getTask())
                    viewModel.addPopover = false
                    viewModel.addText = ""
                }
            GroupBox {
                TaskRow(task: viewModel.addText.getTask().binding { _ in }, theme: theme)
                    .padding(.previewBoxPadding)
            }
            .padding(.previewBoxPadding)
        }
        .padding()
    }

}
