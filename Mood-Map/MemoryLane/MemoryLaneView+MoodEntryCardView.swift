//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI
import MoodMapKit

extension MemoryLaneView {
    @ViewBuilder
    public func MoodEntryCardView(scrollMood: ScrollMood) -> some View {
        VStack(alignment: .leading) {
            Text(scrollMood.date, style: .date)
                .font(.headline)
                .padding()

            ForEach(Array(scrollMood.moods.enumerated()), id: \.1.id) { index, moodEntry in
                Button {
                    withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                        currentItem = moodEntry
                        showDetail = true
                    }
                } label: {

                    MoodEntryCardContentView(moodEntry: moodEntry.data)
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

                }.buttonStyle(ScaledButtonStyle())

            }
            .padding(.leading)
        }
    }

}
