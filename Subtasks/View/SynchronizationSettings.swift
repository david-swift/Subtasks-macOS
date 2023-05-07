//
//  SynchronizationSettings.swift
//  Subtasks
//
//  Created by david-swift on 04.05.23.
//

import PigeonApp
import SwiftUI

/// The view for the synchronization settings tab.
struct SynchronizationSettings: View {

    /// The app model.
    @EnvironmentObject private var appModel: AppModel

    /// The success badge's color.
    private var color: Color {
        appModel.synchronizationSuccess.0 ? .green : .red
    }

    /// The view's body.
    var body: some View {
        GeneralSettingsView(text: .init("Settings", comment: "SynchronizationSettings (Settings button)")) {
            Circle()
                .frame(width: .completionBadgeWidth)
                .foregroundStyle(color.gradient)
                .shadow(color: color, radius: .completionBadgeShadowRadius)
                .overlay {
                    Image(systemSymbol: appModel.synchronizationSuccess.0 ? .checkmark : .xmark)
                        .accessibilityHidden(true)
                        .foregroundStyle(.background)
                        .font(.system(size: .completionBadgeFontSize, weight: .black))
                }
                .onAppear {
                    appModel.setTasks()
                }
            if !appModel.synchronizationSuccess.1.isEmpty {
                Text(appModel.synchronizationSuccess.1)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        } content: {
            textFields
            Section(.init("Tutorial", comment: "SynchronizationSettings (Tutorial Settings)")) {
                steps1To5
                steps6To10
                Text(.init(
                    """
                    create table public.tasks (
                      id integer not null primary key default 0,
                      data text not null
                    );
                    """,
                    comment: "SynchronizationSettings (Code snippet)"
                ))
                .textSelection(.enabled)
                steps11To15
            }
        }
    }

    /// The text fields for editing the Supabase data.
    private var textFields: some View {
        Group {
            TextField(text: $appModel.supabaseURL) {
                Text(.init(
                    "Supabase URL",
                    comment: "SynchronizationSettings (Label of Supabase URL in synchronization settings)"
                ))
            }
            TextField(text: $appModel.supabaseKey) {
                Text(.init(
                    "Supabase Key",
                    comment: "SynchronizationSettings (Label of Supabase key in synchronization settings)"
                ))
            }
            TextField(value: $appModel.supabaseRowID, format: .number) {
                Text(.init(
                    "Collection ID",
                    comment: "SynchronizationSettings (Label of collection ID in synchronization settings)"
                ))
            }
        }
    }

    /// The first five tutorial steps.
    private var steps1To5: some View {
        Group {
            Text(.init(
                "**1.** Sign up or log in on [Supabase](https://app.supabase.com/sign-up).",
                comment: "SynchronizationSettings (Tutorial Step 1)"
            ))
            Text(.init(
                "**2.** Click on `New project`.",
                comment: "SynchronizationSettings (Tutorial Step 2)"
            ))
            Text(.init(
                "**3.** Name your project, and set the password and the region.",
                comment: "SynchronizationSettings (Tutorial Step 3)"
            ))
            Text(.init(
                "**4.** Click on `Create new project`.",
                comment: "SynchronizationSettings (Tutorial Step 4)"
            ))
            Text(.init(
                "**5.** In the screen that now appears, click on `Copy` under Project API keys > anon public.",
                comment: "SynchronizationSettings (Tutorial Step 5)"
            ))
        }
    }

    /// Tutorial steps 6 to 10.
    private var steps6To10: some View {
        Group {
            Text(.init(
                """
                **6.** Paste the copied key with `⌘V` into the `Supabase Key` field above in this settings tab.
                """,
                comment: "SynchronizationSettings (Tutorial Step 6)"
            ))
            Text(.init(
            """
**7.** Hover over the symbols on the left in Supabase. Click on the terminal symbol with the name `SQL Editor`.
""",
            comment: "SynchronizationSettings (Tutorial Step 7)"
            ))
            Text(.init(
                "**8.** Click on `New query` above the search field.",
                comment: "SynchronizationSettings (Tutorial Step 8)"
            ))
            Text(.init(
            """
**9.** Click on the down arrow (`˯`) next to the query's name, click on rename and rename it to \"Create table\".
""",
            comment: "SynchronizationSettings (Tutorial Step 9)"
            ))
            Text(.init(
                "**10.** Paste the following code into the editor:",
                comment: "SynchronizationSettings (Tutorial Step 10)"
            ))
        }
    }

    /// The last five tutorial steps.
    private var steps11To15: some View {
        Group {
            Text(.init(
                "**11.** Click on `Run` in the bottom right corner or press `⌘↩︎`.",
                comment: "SynchronizationSettings (Tutorial Step 11)"
            ))
            Text(.init(
                "**12.** Click on the table icon on the left above the SQL editor symbol.",
                comment: "SynchronizationSettings (Tutorial Step 12)"
            ))
            Text(.init(
                "**13.** Select the table \"tasks\" on the left and click on the button `API` on the top right.",
                comment: "SynchronizationSettings (Tutorial Step 13)"
            ))
            Text(.init(
            """
**14.** Click on `Copy` under API URL > API URL and paste it into the `Supabase URL` field above in this settings tab.
""",
            comment: "SynchronizationSettings (Tutorial Step 14)"
            ))
            Text(.init(
                "**15.** Now, edit a task. Check if a new row is added to the table.",
                comment: "SynchronizationSettings (Tutorial Step 15)"
            ))
        }
    }
}

/// Previews for the synchronization settings.
struct SynchronizationSettings_Previews: PreviewProvider {

    /// The preview.
    static var previews: some View {
        SynchronizationSettings()
    }

}
