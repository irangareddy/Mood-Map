//
//  LargeButton.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 12/06/23.
//

import Foundation
import SwiftUI

/// A large control that initiates an action with custom label
struct LargeButton: View {
    private static let buttonHorizontalMargins: CGFloat = 20

    var backgroundColor: Color
    var foregroundColor: Color
    var cornerRadius: CGFloat

    private var icon: UIImage?

    private let title: String
    private let action: () -> Void

    // It would be nice to make this into a binding.
    private let disabled: Bool
    private let disableMargins: Bool

    /// Creates an instance that generates `LargeButton`
    init(title: String,
         disabled: Bool = false,
         disableMargins: Bool = false,
         backgroundColor: Color = Color.accentColor,
         foregroundColor: Color = Color.white,
         icon: UIImage? = nil,
         cornerRadius: CGFloat = 16,
         action: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.title = title
        self.icon = icon
        self.action = action
        self.disabled = disabled
        self.icon = icon
        self.disableMargins = disableMargins
    }

    var body: some View {
        HStack {
            if !disableMargins {
                Spacer(minLength: LargeButton.buttonHorizontalMargins)
            }

            Button(action: action) {
                HStack(spacing: 15) {
                    if let icon = icon {
                        Image(uiImage: icon)
                            .frame(width: 20, height: 20)
                    }
                    Text(title)
                        .font(.appLargeBody)
                        .transition(.opacity)
                        .id("LargeButton" + title)
                }.frame(maxWidth: .infinity)
            }
            .buttonStyle(LargeButtonStyle(backgroundColor: backgroundColor,
                                          foregroundColor: foregroundColor, cornerRadius: cornerRadius,
                                          isDisabled: disabled))
            .disabled(self.disabled)
            if !disableMargins {
                Spacer(minLength: LargeButton.buttonHorizontalMargins)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

/// Custom button style for Large Button
struct LargeButtonStyle: ButtonStyle {
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
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(currentForegroundColor, lineWidth: 1)
            )
            .padding([.bottom], 8)
    }
}
