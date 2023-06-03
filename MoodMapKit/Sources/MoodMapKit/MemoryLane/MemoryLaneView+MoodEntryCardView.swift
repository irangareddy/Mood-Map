//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

extension MemoryLaneView {
    @ViewBuilder
    public func MoodEntryCardView(scrollMood: ScrollMood) -> some View {
        VStack(alignment: .leading) {
            Text(scrollMood.date, style: .date)
                .font(.headline)
                .padding()

            ForEach(Array(scrollMood.moods.enumerated()), id: \.1.id) { index, moodEntry in
                MoodEntryCardContentView(moodEntry: moodEntry)
                    .padding(.horizontal)
                    .overlay(
                        // Add vertical divider if it's not the last card
                        index != scrollMood.moods.count - 1 ? AnyView(
                            HStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 2, style: .continuous)
                                    .frame(width: 4, height: 16)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        ) : AnyView(EmptyView())
                    )
                    .background(
                        GeometryReader { geometry in
                            Text(randomFaceEmoji())
                                .font(.largeTitle)
                                .position(x: geometry.size.width - 20, y: 10)
                        }
                    )
            }
            .padding(.leading)
        }
    }

    public func randomFaceEmoji() -> String {
        let faceEmojis = ["😀", "😃", "😄", "😊", "😍", "🥳", "😎", "🤩", "🙂", "😉", "😘", "😜", "😝", "🤪", "😮", "🤗"]
        return faceEmojis.randomElement() ?? "😀"
    }

}
