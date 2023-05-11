//
//  TaskRow.swift
//  Subtasks
//
//  Created by david-swift on 28.04.23.
//

import PigeonApp
import SwiftUI

/// A row containing information about a task.
struct TaskRow: View {

    /// The color scheme.
    @Environment(\.colorScheme)
    var colorScheme
    /// The task.
    @Binding var task: Subtask
    /// The current theme.
    var theme: Theme

    /// The view's body.
    var body: some View {
        HStack {
            Group {
                checkBox
                text
                Spacer()
            }
            .badge(task.childrenBadge)
            chevron
        }
    }

    /// A check box that indicates whether the task is completed.
    private var checkBox: some View {
        Button {
            task.isCompleted.toggle()
        } label: {
            Circle()
                .fill(task.isCompleted ? theme.primaryAccent : Color.clear)
                .overlay {
                    Circle()
                        .strokeBorder(task.isCompleted ? .clear : .gray, lineWidth: .completeStrokeWidth)
                }
                .overlay {
                    Image(systemSymbol: .checkmark)
                        .accessibilityLabel(.init(
                            "Completed",
                            comment: "TaskRow (Accessibility label of completed checkmark)"
                        ))
                        .foregroundColor(.white)
                        .bold()
                        .padding(.completedCheckmarkPadding)
                        .opacity(task.isCompleted ? 1 : 0)
                }
                .frame(width: .completeButtonSideLength)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(.trailing, .completeButtonPadding)
    }

    /// The title and description of the task and an exclamation mark indicating the priority.
    private var text: some View {
        VStack(alignment: .leading) {
            HStack {
                if task.highPriority {
                    Text("!")
                        .foregroundColor(theme.secondaryAccent)
                        .padding(.trailing, .exclamationMarkPadding)
                }
                Text(LocalizedStringKey(task.title))
            }
            if !task.description.isEmpty {
                Text(LocalizedStringKey(task.description))
                    .foregroundColor(.secondary)
            }
        }
    }

    /// A symbol indicating that the user can navigate by clicking on the task.
    private var chevron: some View {
        Image(systemSymbol: .chevronRight)
            .bold()
            .foregroundColor(theme.primaryAccent)
            .accessibilityHidden(true)
    }

}
