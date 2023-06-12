//
//  SmallButton.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 12/06/23.
//

import Foundation
import SwiftUI

/// A small control that initiates an action with custom label
struct SmallButton: View {
    private static let buttonHorizontalMargins: CGFloat = 8

    var backgroundColor: Color
    var foregroundColor: Color
    var cornerRadius: CGFloat

    private let title: String
    private let action: () -> Void

    // It would be nice to make this into a binding.
    private let disabled: Bool

    /// Creates an instance that generates `SmallButton`
    init(title: String,
         disabled: Bool = false,
         backgroundColor: Color = Color.accentColor,
         foregroundColor: Color = Color.white,
         cornerRadius: CGFloat = 16,
         action: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.title = title
        self.action = action
        self.disabled = disabled
    }

    var body: some View {
        HStack {
            Spacer(minLength: SmallButton.buttonHorizontalMargins)
            Button(action: action) {
                Text(title)
                    .font(.appLargeBody)
            }
            .buttonStyle(SmallButtonStyle(backgroundColor: backgroundColor,
                                          foregroundColor: foregroundColor, cornerRadius: cornerRadius,
                                          isDisabled: disabled))
            .disabled(self.disabled)
            Spacer(minLength: SmallButton.buttonHorizontalMargins)
        }
    }
}

/// Custom button style for Small Button
struct SmallButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let cornerRadius: CGFloat
    let isDisabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        let currentForegroundColor = isDisabled || configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor
        return configuration.label
            .padding()
            .foregroundColor(currentForegroundColor)
            .background(isDisabled || configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor)
            // This is the key part, we are using both an overlay as well as cornerRadius
            .cornerRadius(cornerRadius)
            .padding([.bottom], 8)
    }
}
