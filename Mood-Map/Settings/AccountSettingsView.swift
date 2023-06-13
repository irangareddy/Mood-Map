//
//  AccountSettingsView.swift
//  MoodMapKit
//
//  Created by Ranga Reddy Nukala on 30/05/23.
//

import SwiftUI
import MoodMapKit

/// A view that displays the account settings options.
///
/// Use `AccountSettingsView` to create a view that shows various account settings options.
/// It uses the `AccountSettingsButton` component to create clickable buttons with titles, actions, and optional description texts.
public struct AccountSettingsView: View {
    @ObservedObject private var authManager = AuthViewModel.shared

    // Action enum
    public enum AccountAction {
        case editDisplayName
        case logout
        case deleteAccount
    }

    // Action variable
    @State private var selectedAction: AccountAction?

    // Public initializer
    public init(selectedAction: AccountAction? = nil) {
        self._selectedAction = State(initialValue: selectedAction)
    }

    // Function to perform action
    private func performAction(_ action: AccountAction) {
        switch action {
        case .editDisplayName:
            // Perform action for "Edit Display Name"
            break
        case .logout:
            // Perform action for "Log out"

            break
        case .deleteAccount:
            // Perform action for "Delete Account"

            break
        }
    }

    // Button function
    private func buttonAction(_ action: AccountAction) {
        selectedAction = action
    }

    // The body view of the AccountSettingsView
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AccountSettingsButton(title: "Edit Display Name") {
                buttonAction(.editDisplayName)
            }.description("This feature is temporarily disabled.")
            .disabled(true)

            AccountSettingsButton(title: "Log out") {
                logout(session: .current)
            }
            .description("When you log out, you will be signed out of your account and any unsaved data may be lost.")

            AccountSettingsButton(title: "Delete Account") {
                logout(session: .all)
            }
            .description("When you delete your account, you will be logged out of all sessions. After 30 days of inactivity, your account information and data are permanently removed.")

            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .navigationTitle("Account Settings")
        .onAppear {
            if let selectedAction = selectedAction {
                performAction(selectedAction)
                self.selectedAction = nil // Reset the selected action after performing it
            }
        }
    }
    private func logout(session: AppwriteSessions) {
        Task {
            await authManager.deleteSession(session: session)
        }

    }

}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
    }
}
