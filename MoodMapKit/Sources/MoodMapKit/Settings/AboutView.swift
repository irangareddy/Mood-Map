//
//  AboutView.swift
//  MoodMapKit
//
//  Created by Ranga Reddy Nukala on 30/05/23.
//

import SwiftUI

/// A view that displays information about the app and related links.
///
/// Use `AboutView` to create a view that shows links such as Learn More, Terms of Service, and Privacy Policy.
/// It uses the `LinkButton` component to create clickable buttons with titles, URLs, and system images.
public struct AboutView: View {
    /// The body view of the AboutView.
    public var body: some View {
        VStack(spacing: 16) {
            LinkButton(title: "Learn More", url: URL(string: "https://your-learn-more-url.com")!, systemImage: "arrow.up.right.square")

            LinkButton(title: "Terms of Service", url: URL(string: "https://your-terms-of-service-url.com")!, systemImage: "doc.text")

            LinkButton(title: "Privacy Policy", url: URL(string: "https://your-privacy-policy-url.com")!, systemImage: "shield")

            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .navigationTitle("Account Settings")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
