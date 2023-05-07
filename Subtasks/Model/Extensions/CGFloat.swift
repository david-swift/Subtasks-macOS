//
//  CGFloat.swift
//  Subtasks
//
//  Created by david-swift on 03.05.23.
//
//  swiftlint:disable no_magic_numbers

import Foundation

extension CGFloat {

    /// The with of the popover for creating a task.
    static var createTaskFieldWidth: CGFloat { 200 }
    /// The padding around the preview box for creating a task.
    static var previewBoxPadding: CGFloat { 5 }
    /// The minimal width of the window.
    static var windowMinWidth: CGFloat { 300 }
    /// The ideal width of the window.
    static var windowIdealWidth: CGFloat { 450 }
    /// The minimal height of the window.
    static var windowMinHeight: CGFloat { 150 }
    /// The ideal height of the window.
    static var windowIdealHeight: CGFloat { 350 }
    /// The padding around the text of a task row.
    static var taskRowPadding: CGFloat { 10 }
    /// The padding around the background of a task row.
    static var listRowBackgroundPadding: CGFloat { 5 }
    /// The width of the task informatino sheet.
    static var taskInformationSheetWidth: CGFloat { 300 }
    /// The height of the task informatino sheet.
    static var taskInformationSheetHeight: CGFloat { 250 }
    /// The width of the circle around the completion button.
    static var completeStrokeWidth: CGFloat { 1.5 }
    /// Padding around a checkmark for indicating that a task is completed.
    static var completedCheckmarkPadding: CGFloat { 5 }
    /// The side length of the completion button in a task row.
    static var completeButtonSideLength: CGFloat { 20 }
    /// Padding around a completion button in a task row.
    static var completeButtonPadding: CGFloat { 10 }
    /// Padding between the exclamation mark and title in a task row.
    static var exclamationMarkPadding: CGFloat { -10 }
    /// The width of the preview in the themes settings tab.
    static var themesPreviewWidth: CGFloat { 300 }
    /// The width of the completion badge in the synchronization settings tab.
    static var completionBadgeWidth: CGFloat { 200 }
    /// The radius of the completion badge's shadow.
    static var completionBadgeShadowRadius: CGFloat { 30 }
    /// The font size of the completion badge's shadow.
    static var completionBadgeFontSize: CGFloat { 100 }

}

//  swiftlint:enable no_magic_numbers
