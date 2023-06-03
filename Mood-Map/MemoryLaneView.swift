//
//  MemoryLaneView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import MoodMapKit

public struct MemoryLaneViewWrapper: View {
    @Binding var moodEntries: [MoodEntry]

    public init(moodEntries: Binding<[MoodEntry]>) {
        _moodEntries = moodEntries
    }

    public var body: some View {
        MemoryLaneView(moodEntries: $moodEntries)
    }
}

struct MemoryLaneViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        let previewData = PlaceholderData()
        MemoryLaneViewWrapper(moodEntries: Binding<[MoodEntry]>(
            get: { previewData.moodEntries },
            set: { previewData.moodEntries = $0 }
        ))
    }
}
