//
//  File 2.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

extension MemoryLaneView {
    /// Adjusts the elevation and appearance of the dates in the memory lane based on the current offset.
    func dateElevation() {
        guard let currentIndex = groupedMoodEntries.firstIndex(where: { scrollMood in
            scrollMood.rect.contains(CGPoint(x: 0, y: offsetY))
        }) else {
            return
        }

        var modifiedIndices: [Int] = []

        groupedMoodEntries.indices.forEach { index in
            if index == currentIndex {
                groupedMoodEntries[index].pushOffset = -35
                groupedMoodEntries[index].isCurrent = true
                currentActiveIndex = index
                print("🙈 Current Active Index: \(currentActiveIndex)")

            } else {
                groupedMoodEntries[index].pushOffset = 0
                groupedMoodEntries[index].isCurrent = false
            }
        }

        let otherOffsets: [CGFloat] = [-25, -15, -5]
        for indexOffset in otherOffsets.indices {
            let newIndex = currentIndex + (indexOffset + 1)
            let newNegativeIndex = currentIndex - (indexOffset + 1)

            if verifyAndUpdate(index: newIndex, offset: otherOffsets[indexOffset]) {
                modifiedIndices.append(newIndex)
            }

            if verifyAndUpdate(index: newNegativeIndex, offset: otherOffsets[indexOffset]) {
                modifiedIndices.append(newNegativeIndex)
            }
        }
    }
    // Utility Functions

    // ...
}
