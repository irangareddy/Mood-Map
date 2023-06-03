//
//  AccountSettingsButton.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import SwiftUI

/// A button for account settings options.
///
/// Use `AccountSettingsButton` to create a button with a specific title and action closure for account settings.
/// It can also display an optional description text below the title.
public struct AccountSettingsButton: View {
    /// The title of the button.
    let title: String

    /// The closure to execute when the button is tapped.
    let action: () -> Void

    /// The optional description text displayed below the title.
    var descriptionText: String?

    /// Initializes an `AccountSettingsButton` with a title and action closure.
    ///
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - action: The closure to execute when the button is tapped.
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    /// The body view of the AccountSettingsButton.
    public var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .foregroundColor(title.contains("Delete") ? Color.red : Color.primary) // Adjust the color as needed
                    .font(.appHeadline)
                    .padding(.bottom, 4)

                if let descriptionText = descriptionText {
                    Text(descriptionText)
                        .font(.appCaption)
                        .padding(.top, 2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                } else {
                    Divider()
                }
            }
            .padding(8)
        }
    }

    /// Sets the description text for the button.
    ///
    /// - Parameter text: The description text.
    /// - Returns: An `AccountSettingsButton` with the updated description text.
    public func description(_ text: String) -> AccountSettingsButton {
        var copy = self
        copy.descriptionText = text
        return copy
    }
}
