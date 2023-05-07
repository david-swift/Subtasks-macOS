//
//  Array.swift
//  Subtasks
//
//  Created by david-swift on 25.04.23.
//

import ColibriComponents
import SwiftUI

extension Array where Element == Subtask {

    /// Get the task with a certain id from an array with subtasks.
    /// - Parameter id: The task's identifier.
    /// - Returns: The task.
    func getTask(id: UUID) -> Subtask? {
        for element in self {
            if element.id == id {
                return element
            } else if let task = element.subtasks.getTask(id: id) {
                return task
            }
        }
        return nil
    }

    /// Set a task with a certain id in an array with subtasks.
    /// - Parameters:
    ///   - id: The task's identifier.
    ///   - task: The new value.
    mutating func setTask(id: UUID, task: Subtask) {
        for (index, element) in self.enumerated() {
            if element.id == id {
                self[safe: index] = task
            } else {
                self[safe: index]?.subtasks.setTask(id: id, task: task)
            }
        }
    }

}
