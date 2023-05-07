//
//  Subtask.swift
//  Subtasks
//
//  Created by david-swift on 24.04.23.
//

import ColibriComponents
import SwiftUI

/// A task.
public struct Subtask: Identifiable, Codable, Equatable, Bindable {

    /// The task's id.
    public let id: UUID
    /// Whether the task is completed.
    var isCompleted = false
    /// The task's title.
    var title: String
    /// A description of the task.
    var description: String = .init()
    /// The task's priority.
    var highPriority = false
    /// The subtasks.
    var subtasks: [Subtask] = []

    /// A badge showing the amount of subtasks that are not completed.
    var childrenBadge: Int {
        var count = subtasks.filter { !$0.isCompleted }.count
        for subtask in subtasks {
            count += subtask.childrenBadge
        }
        return isCompleted ? 0 : count
    }

    /// Whether there is a subtask with a high priority that is not completed.
    var highPriorityChild: Bool {
        for subtask in subtasks where (subtask.highPriority || subtask.highPriorityChild) && !subtask.isCompleted {
            return true
        }
        return false
    }

    /// Initialize a task.
    /// - Parameters:
    ///   - id: The task's id.
    ///   - title: The task's title.
    init(
        id: UUID = .init(),
        title: String = .init(localized: .init("New Task", comment: "Subtasks (Standard title of a task)"))
    ) {
        self.id = id
        self.title = title
    }

    /// Copy a subtask but change the identifier.
    /// - Returns: The new task.
    func new() -> Self {
        var new = Self(title: title)
        new.isCompleted = isCompleted
        new.description = description
        new.highPriority = highPriority
        new.subtasks = subtasks
        return new
    }

}
