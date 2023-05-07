//
//  SubtasksCommands.swift
//  Subtasks
//
//  Created by david-swift on 30.04.23.
//

import ColibriComponents
import SwiftUI

/// The app's commands.
struct SubtasksCommands: Commands {

    /// The shared instance of the app model.
    @StateObject private var appModel = AppModel.shared
    /// The model for the focused window.
    @FocusedObject private var viewModel: ViewModel?

    /// The commands.
    var body: some Commands {
        CommandGroup(before: .newItem) {
            Button(.init("New Task", comment: "SubtasksCommands (Button for adding a task)")) {
                viewModel?.addTask()
            }
            .keyboardShortcut("n")
            .disabled(otherFocus)
        }
        CommandGroup(after: .newItem) {
            Group {
                Divider()
                Button(.init("Show Subtasks", comment: "SubtasksCommands (Button for showing the subtasks)")) {
                    viewModel?.showSubtasks()
                }
                .keyboardShortcut(.rightArrow, modifiers: arrowModifiers())
                .disabled(noSelection)
                Button(.init("Show Parent", comment: "SubtasksCommands (Button for showing the parent task)")) {
                    viewModel?.showParent()
                }
                .keyboardShortcut(.leftArrow, modifiers: arrowModifiers())
                .disabled(superTask)
            }
            .disabled(otherFocus)
        }
        CommandGroup(after: .pasteboard) {
            Divider()
            Button(.init("Delete Task", comment: "SubtasksCommands (Button for deleting the selected task)")) {
                viewModel?.deleteTask()
            }
            .keyboardShortcut(.delete, modifiers: appModel.useCommandForDeleting ? .command : [])
            .disabled(noSelection || otherFocus)
            Button(.init(
                "Select Previous Task",
                comment: "SubtasksCommands (Button for selecting the previous task)"
            )) {
                viewModel?.select(index: -1)
            }
            .keyboardShortcut(.upArrow, modifiers: [])
            Button(.init("Select Next Task", comment: "SubtasksCommands (Button for selecting the next task)")) {
                viewModel?.select(index: 1)
            }
            .keyboardShortcut(.downArrow, modifiers: [])
            Divider()
            taskToggles
        }
        CommandGroup(after: .toolbar) {
            Toggle(String(localized: .init(
                "Task Info",
                comment: "SubtasksCommands (Toggle for changing the information sheet's visibility)"
            )), isOn: (viewModel?.information ?? false).binding { newValue in
                viewModel?.information = newValue
            })
            .keyboardShortcut("i")
            .disabled(noSelection)
            Divider()
        }
    }

    /// Toggles for editing the selected task.
    /// Displayed in the "Edit" menu.
    private var taskToggles: some View {
        Group {
            Toggle(String(localized: .init(
                "Completed",
                comment: "SubtasksCommands (Toggle for changing the selected task's completion)"
            )), isOn: $viewModel?.completed ?? .constant(false))
                .keyboardShortcut(.defaultAction)
            Toggle(String(localized: .init(
                "High Priority",
                comment: "SubtasksCommands (Toggle for changing the selected task's priority)"
            )), isOn: $viewModel?.highPriority ?? .constant(false))
                .keyboardShortcut(.upArrow)
        }
        .disabled(noSelection)
    }

    /// There is no task selected.
    private var noSelection: Bool {
        viewModel?.getSelectedTask() == nil
    }

    /// The active task is the top level task.
    private var superTask: Bool {
        viewModel?.focusedTasks.isEmpty ?? false
    }

    /// Another UI element (the popover for adding a task or the information sheet) is focused.
    private var otherFocus: Bool {
        viewModel?.addPopover ?? false || viewModel?.information ?? false
    }

    /// The modifiers for the navigation commands.
    /// - Returns: The modifiers.
    private func arrowModifiers() -> EventModifiers {
        if appModel.useCommandForNavigation {
            return [.command]
        } else {
            return []
        }
    }

}
