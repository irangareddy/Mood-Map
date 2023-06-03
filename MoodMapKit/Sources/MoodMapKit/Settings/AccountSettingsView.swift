//
//  AccountSettingsView.swift
//  MoodMapKit
//
//  Created by Ranga Reddy Nukala on 30/05/23.
//

import SwiftUI

/// A view that displays the account settings options.
///
/// Use `AccountSettingsView` to create a view that shows various account settings options.
/// It uses the `AccountSettingsButton` component to create clickable buttons with titles, actions, and optional description texts.
public struct AccountSettingsView: View {
    /// The body view of the AccountSettingsView.
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AccountSettingsButton(title: "Edit Display Name") {
                // Perform action for "Edit Display Name"
            }

            AccountSettingsButton(title: "Log out") {
                // Perform action for "Log out"
            }
            .description("When you log out, you will be signed out of your account and any unsaved data may be lost.")

            AccountSettingsButton(title: "Delete Account") {
                // Perform action for "Delete Account"
            }
            .description("When you delete your account, all of your account information and data will be permanently removed. This action cannot be undone.")

            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .navigationTitle("Account Settings")
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
    }
}
