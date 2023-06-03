//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

/// A button that represents a link to a URL.
///
/// Use `LinkButton` to create a button that, when tapped, opens the provided URL.
/// It displays a title and a system image alongside the title.
public struct LinkButton: View {
    /// The title of the button.
    let title: String

    /// The destination URL.
    let url: URL

    /// The system image name to be displayed alongside the title.
    let systemImage: String

    /// Initializes a new instance of `LinkButton`.
    ///
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - url: The destination URL.
    ///   - systemImage: The system image name to be displayed alongside the title.
    public init(title: String, url: URL, systemImage: String) {
        self.title = title
        self.url = url
        self.systemImage = systemImage
    }

    /// The body view of the LinkButton.
    public var body: some View {
        Link(destination: url) {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(.appHeadline)
                    }
                    Spacer()
                    Image(systemName: systemImage)
                        .font(.body)
                        .padding(.trailing)
                }
                .foregroundColor(.primary)
                .padding(.bottom, 4)
                Divider()
            }
            .padding(.horizontal, 8)
        }
    }
}
