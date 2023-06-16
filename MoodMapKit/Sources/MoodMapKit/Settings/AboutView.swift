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
    ///
    public init() {}

    public var body: some View {
        VStack(spacing: 16) {
            LinkButton(title: "Learn More", url: URL(string: "https://irangareddy.hashnode.dev/mood-map-appwrite-hashnode-hackathon")!, systemImage: "arrow.up.right.square")

            LinkButton(title: "Terms of Service", url: URL(string: "https://github.com/irangareddy/Mood-Map/blob/develop/Terms/terms-and-conditions.md")!, systemImage: "doc.text")

            LinkButton(title: "Privacy Policy", url: URL(string: "https://github.com/irangareddy/Mood-Map/blob/develop/Terms/privacy-policy.md")!, systemImage: "shield")

            LinkButton(title: "Version", systemImage: AppInfo.appVersion)
            LinkButton(title: "Build Number", systemImage: AppInfo.buildNumber)

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
