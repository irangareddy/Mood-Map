//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

/// A button that navigates to a destination view when tapped.
///
/// Use `NavigationButton` to create a button that, when tapped, navigates to the specified destination view.
/// It displays a label, system image, and an arrow icon indicating the navigation direction.
public struct NavigationButton<Destination: View>: View {
    /// The destination view to navigate to.
    let destination: Destination

    /// The label of the button.
    let label: String

    /// The system image name to be displayed alongside the label.
    let systemImage: String

    /// Initializes a new instance of `NavigationButton`.
    ///
    /// - Parameters:
    ///   - destination: The destination view to navigate to.
    ///   - label: The label of the button.
    ///   - systemImage: The system image name to be displayed alongside the label.
    public init(destination: Destination, label: String, systemImage: String) {
        self.destination = destination
        self.label = label
        self.systemImage = systemImage
    }

    /// The body view of the NavigationButton.
    public var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: systemImage)
                        .frame(width: 22)
                        .padding(.trailing, 8)
                        .foregroundColor(.accentColor)

                    Text(label)
                        .font(.appHeadline)

                    Spacer()

                    Image(systemName: "arrow.right")
                        .padding(.trailing, 4)
                }
                Divider()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .foregroundColor(.primary)
        }
    }
}
