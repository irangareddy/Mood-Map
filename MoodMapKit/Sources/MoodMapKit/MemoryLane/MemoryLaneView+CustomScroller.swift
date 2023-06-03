//
//  MemoryLaneView+CustomScroller.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

extension MemoryLaneView {
    /// A custom slider view used for scrolling through memory lane entries.
    ///
    /// The `CustomScroller` displays the dates of the memory lane entries and allows the user to scroll through them.

    @ViewBuilder
    public func CustomScroller() -> some View {
        GeometryReader { proxy in
            let rect = proxy.frame(in: .named("SCROLLER"))

            VStack {
                ForEach(groupedMoodEntries.indices, id: \.self) { index in
                    let scrollMoodBinding = $groupedMoodEntries[index]
                    let scrollMood = scrollMoodBinding.wrappedValue

                    HStack(spacing: 15) {
                        GeometryReader { innerProxy in
                            let origin = innerProxy.frame(in: .named("SCROLLER"))

                            Text(scrollMood.userFriendlyDate)
                                .font(.caption)
                                .fontWeight(scrollMood.isCurrent ? .bold : .semibold)
                                .foregroundColor(scrollMood.isCurrent ? .primary : .secondary)
                                .scaleEffect(scrollMood.isCurrent ? 0.8 : 0.6)
                                .contentTransition(.interpolate)
                                .frame(width: origin.size.width, height: origin.size.height, alignment: .trailing)
                                .overlay {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 15, height: 0.8)
                                        .offset(x: 45)
                                }
                                .offset(x: scrollMood.pushOffset)
                                .animation(.easeInOut(duration: 0.2), value: scrollMood.pushOffset)
                                .animation(.easeInOut(duration: 0.2), value: scrollMood.isCurrent)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        scrollMoodBinding.wrappedValue.rect = origin
                                    }
                                }
                        }

                        ZStack {
                            if groupedMoodEntries.first?.date == scrollMood.date {
                                ScrollerKnob(moodEntry: $currentMoodEntry, rect: rect)
                            }
                        }
                        .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .frame(width: 100)
        .padding(.trailing, 10)
        .coordinateSpace(name: "SCROLLER")
        .padding(.vertical, 15)
    }

    // Utility Functions

    // ...
}
