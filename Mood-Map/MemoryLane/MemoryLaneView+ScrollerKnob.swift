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
    /// A knob view used for scrolling through the memory lane.
    ///
    /// The `ScrollerKnob` allows the user to drag and scroll through the memory lane entries.
    @ViewBuilder
    public func ScrollerKnob(moodEntry: Binding<ScrollMood>, rect: CGRect) -> some View {
        Circle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#737DFE"), Color(hex: "#FFCAC9")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .background(Circle().stroke(Color.primary, lineWidth: 5))
            .overlay(content: {
                Circle()
                    .fill(.white)
                    .opacity(isDragging ? 0.8 : 0.0001)
            })
            .scaleEffect(isDragging ? 1.35 : 1)
            .animation(.easeInOut(duration: 0.2), value: isDragging)
            .offset(y: offsetY)
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($isDragging, body: { _, out, _ in
                        out = true
                    }).onChanged({ value in
                        var transition = value.location.y - 20
                        transition = min(transition, (rect.maxY - 20))
                        transition = max(transition, rect.minY)
                        offsetY = transition
                        dateElevation()
                    })
                    .onEnded({ _ in
                        if groupedMoodEntries.indices.contains(currentActiveIndex) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                offsetY = groupedMoodEntries[currentActiveIndex].rect.minY
                            }
                        }
                    })

            )
    }

    // Utility Functions

    func verifyAndUpdate(index: Int, offset: CGFloat) -> Bool {
        if groupedMoodEntries.indices.contains(index) {
            groupedMoodEntries[index].pushOffset = offset
            groupedMoodEntries[index].isCurrent = false
            return true
        }
        return false
    }

}
