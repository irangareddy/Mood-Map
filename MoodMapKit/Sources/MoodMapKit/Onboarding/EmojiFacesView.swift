//
//  EmojiFacesView.swift
//
//
//  Created by Ranga Reddy Nukala on 03/06/23.
//

import Foundation
import SwiftUI

// MARK: - EmojiFacesView

/// A view that displays animated faces.
public struct EmojiFacesView: View {
    /// The available emoji faces.
    public static let emoji = ["😀", "😬", "😄", "🙂", "😗", "🤓", "😏", "😕", "😟", "😎", "😜", "😍", "🤪"]

    @State private var animatedText = false

    public init(animatedText: Bool = false) {
        self.animatedText = animatedText
    }

    /// The body view that constructs the UI hierarchy.
    public var body: some View {
        TimelineView(.periodic(from: .now, by: 0.2)) { timeline in
            VStack(spacing: 30) {
                HStack(spacing: 30) {
                    let randomEmoji = EmojiFacesView.emoji.randomElement() ?? ""

                    Group {
                        Text("M")
                            .offset(x: animatedText ? 0 : -100)

                        Text(randomEmoji)

                        EmojiAnimationView(date: timeline.date)

                        Text("D")
                            .offset(x: animatedText ? 0 : 100)
                    }
                    .font(.appTitle)
                    .scaleEffect(2.0)
                }
                .onAppear {
                    withAnimation(.spring()) {
                        animatedText = true
                    }
                }

                HStack(spacing: 10) {
                    Group {
                        Text("M")
                            .offset(x: animatedText ? 0 : -1000)
                        Text("A")
                            .offset(y: animatedText ? 0 : 1000)
                        Text("P")
                            .offset(x: animatedText ? 0 : 1000)
                    }
                    .font(.appHeadline)
                    .scaleEffect(animatedText ? 2.0 : 1.0)
                }
            }
        }
    }
}

// MARK: - EmojiAnimationView

/// A view that displays a random emoji face.
public struct EmojiAnimationView: View {
    /// The current date.
    public let date: Date

    /// Creates an `EmojiAnimationView` with the specified date.
    /// - Parameter date: The current date.
    public init(date: Date) {
        self.date = date
    }

    public var body: some View {
        let randomEmoji = EmojiFacesView.emoji.randomElement() ?? ""
        Text(randomEmoji)
            .font(.appTitle)
    }
}
