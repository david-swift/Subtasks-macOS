//
//  ViewModel.swift
//  Subtasks
//
//  Created by david-swift on 23.04.23.
//

import SwiftUI

/// The view model for the main view.
@MainActor
class ViewModel: ObservableObject {

    /// The selected task's index.
    @Published var selection = 0
    /// The path to the active task.
    @Published var focusedTasks: [UUID] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(focusedTasks) {
                UserDefaults.standard.set(data, forKey: .navigationID)
            }
        }
    }
    /// Whether the popover for adding a task is visible.
    @Published var addPopover = false
    /// The text in the text field for adding a task.
    @Published var addText: String = .init()
    /// Whether the sheet containing information is visible.
    @Published var information = false

    /// Whether the selected task is completed.
    var completed: Bool {
        get {
            getSelectedTask()?.isCompleted ?? false
        }
        set {
            if var task = getSelectedTask() {
                task.isCompleted = newValue
                AppModel.shared.tasks.setTask(id: task.id, task: task)
            }
        }
    }

    /// Whether the selected task's priority is high.
    var highPriority: Bool {
        get {
            getSelectedTask()?.highPriority ?? false
        }
        set {
            if var task = getSelectedTask() {
                task.highPriority = newValue
                AppModel.shared.tasks.setTask(id: task.id, task: task)
            }
        }
    }

    /// Initialize a view model.
    init() {
        if let data = UserDefaults.standard.value(forKey: .navigationID) as? Data,
           let value = try? JSONDecoder().decode([UUID].self, from: data) {
            focusedTasks = value
        }
    }

    /// Add a task.
    func addTask() {
        addPopover = true
    }

    /// Show the subtasks.
    func showSubtasks() {
        if let selection = getSelectedTask() {
            focusedTasks.append(selection.id)
            updateSelection()
        }
    }

    /// Show the parent task.
    func showParent() {
        _ = focusedTasks.popLast()
        updateSelection()
    }

    /// Select a task when changing the environment.
    func updateSelection() {
        select(index: -1)
        select(index: 1)
    }

    /// Get the active task, that means the parent task of the displayed tasks.
    /// - Returns: The active task.
    func getActiveTask() -> Subtask? {
        if let id = focusedTasks.last, let task = AppModel.shared.tasks.getTask(id: id) {
            return task
        }
        return nil
    }

    /// Get the selected task.
    /// - Returns: The selected task.
    func getSelectedTask() -> Subtask? {
        if let task = getActiveTask() {
            return task.subtasks[safe: selection]
        } else {
            return AppModel.shared.tasks[safe: selection]
        }
    }

    /// Add a task.
    /// - Parameter task: The task to add.
    func addTask(task: Subtask) {
        if var activeTask = getActiveTask() {
            activeTask.subtasks.append(task)
            AppModel.shared.tasks.setTask(id: activeTask.id, task: activeTask)
            selection = activeTask.subtasks.count - 1
        } else {
            AppModel.shared.tasks.append(task)
            selection = AppModel.shared.tasks.count - 1
        }
    }

    /// Delete the selected task.
    func deleteTask() {
        let task = getSelectedTask()
        if var parent = getActiveTask() {
            parent.subtasks = parent.subtasks.filter { $0.id != task?.id }
            AppModel.shared.tasks.setTask(id: parent.id, task: parent)
        } else {
            AppModel.shared.tasks = AppModel.shared.tasks.filter { $0.id != task?.id }
        }
        updateSelection()
    }

    /// Select another task by changing the selection index by the given index.
    /// - Parameter index: The change of the selection index.
    func select(index: Int) {
        selection += index
        if selection >= getActiveTask()?.subtasks.count ?? AppModel.shared.tasks.count {
            selection = 0
        } else if selection < 0 {
            selection = (getActiveTask()?.subtasks.count ?? AppModel.shared.tasks.count) - 1
        }
    }

}
