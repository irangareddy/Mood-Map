//
//  MailView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 30/05/23.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
import MessageUI

/// A SwiftUI representation of a mail composer view for sending feedback emails.
///
/// Use `MailView` to present a mail composer view within your SwiftUI app, allowing users to send feedback emails to a specified email address.
struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    /// The version of the app.
    var appVersion: String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown"
        }
        return appVersion
    }

    /// The coordinator class that handles mail compose events.
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    /// Creates a coordinator for the mail view.
    /// - Returns: The created coordinator.
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }

    /// Creates the mail composer view controller.
    /// - Parameter context: The context information for creating the view controller.
    /// - Returns: The created mail composer view controller.
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients(["sairangareddy22@gmail.com"])
        viewController.setSubject("Feedback for \(AppInfo.appName ?? "App")")
        viewController.setMessageBody(
            """
                Hi,

                I would like to provide the following feedback about \(AppInfo.appName ?? "the app"):

                App Name: \(AppInfo.appName ?? "Unknown")
                App Version: \(AppInfo.appVersion)

                [Please write your feedback here]

                Regards,
                [Your Name]
                """,
            isHTML: false
        )
        return viewController
    }

    /// Updates the mail composer view controller.
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}

/// A struct that provides information about the app.
struct AppInfo {
    /// The name of the app.
    static var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }

    /// The version of the app.
    static var appVersion: String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown"
        }
        return appVersion
    }

    /// The build number of the app.
    static var buildNumber: String {
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return "Unknown"
        }
        return buildNumber
    }
}
#endif
