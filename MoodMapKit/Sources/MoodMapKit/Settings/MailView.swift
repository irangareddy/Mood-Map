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
#endif

/// A SwiftUI representation of a mail composer view for sending feedback emails.
///
/// Use `MailView` to present a mail composer view within your SwiftUI app, allowing users to send feedback emails to a specified email address.
public struct MailView: UIViewControllerRepresentable {
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
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        public init(presentation: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
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
    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }

    /// Creates the mail composer view controller.
    /// - Parameter context: The context information for creating the view controller.
    /// - Returns: The created mail composer view controller.
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
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
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }

    /// Initializes a new instance of the mail view.
    /// - Parameter result: Binding to a result that represents the outcome of the mail composition.
    public init(result: Binding<Result<MFMailComposeResult, Error>?>) {
        _result = result
    }
}

/// A struct that provides information about the app.
public struct AppInfo {
    /// The name of the app.
    public static var appName: String? {
        guard let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else {
            return "Moood Map"
        }
        return appName
    }

    /// The version of the app.
    public static var appVersion: String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown"
        }
        return appVersion
    }

    /// The build number of the app.
    public static var buildNumber: String {
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return "Unknown"
        }
        return buildNumber
    }
}
