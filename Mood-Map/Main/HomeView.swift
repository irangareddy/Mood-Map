//
//  HomeView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var authManager = AuthViewModel.shared

    var body: some View {
        Form {
            if let user = authManager.currentUser {

                Section(header: Text("User Details")) {
                    KeyValueRow(key: "ID", value: user.id)
                    KeyValueRow(key: "Created At", value: user.createdAt.humanReadableDateTime())
                    KeyValueRow(key: "Updated At", value: user.updatedAt.humanReadableDateTime())
                    KeyValueRow(key: "Name", value: user.name)
                    KeyValueRow(key: "Email", value: user.email)
                    KeyValueRow(key: "Phone", value: user.phone)
                    KeyValueRow(key: "Email Verification", value: "\(user.emailVerification)")
                    KeyValueRow(key: "Phone Verification", value: "\(user.phoneVerification)")
                }

                Section(header: Text("Preferences")) {
                    ForEach(user.prefs.data.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        KeyValueRow(key: key, value: "\(value)")
                    }
                }
            }

            Button(action: {
                logout()
            }) {
                Text("Logout")
                    .foregroundColor(.red)
            }
        }            .redacted(reason: authManager.currentUser == nil ? .placeholder : [])

        .onAppear {
            authManager.getCurrentUserDetails()
        }
    }

    private func logout() {
        authManager.deleteSession(session: .current)
        showSplashScreen()
    }

    private func showSplashScreen() {
        // Code to navigate to the splash screen view or present it modally
        // Replace this with your actual implementation
        // For example, you can use navigation controllers, view controllers, or SwiftUI navigation to show the splash screen
    }
}

struct KeyValueRow: View {
    let key: String
    let value: String

    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

extension String {
    func humanReadableDateTime() -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        guard let date = isoDateFormatter.date(from: self) else {
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        return dateFormatter.string(from: date)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
