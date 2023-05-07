//
//  ThemesPreview.swift
//  Subtasks
//
//  Created by david-swift on 03.05.23.
//

import PigeonApp
import SwiftUI

/// The preview for the themes settings tab.
struct ThemesPreview: View {

    /// The global color scheme.
    @Environment(\.colorScheme) var colorScheme
    /// The selected theme.
    var theme: SchemeTheme

    /// The view's body.
    var body: some View {
        let task = { () -> Subtask in
            var task = Subtask(title: .init(localized: .init(
                "Themes",
                comment: "SubtasksApp (Title of themes subtask)"
            )))
            task.isCompleted = true
            task.highPriority = true
            return task
        }()
        TaskRow(task: .constant(task), theme: theme.activeTheme(scheme: colorScheme))
            .frame(width: .themesPreviewWidth)
            .padding()
            .background(
                .gray.opacity(.listRowBackgroundOpacity),
                in: RoundedRectangle(cornerRadius: .colibriCornerRadius)
            )
    }
}
