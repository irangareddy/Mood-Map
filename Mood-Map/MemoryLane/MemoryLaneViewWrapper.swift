//
//  MemoryLaneViewWrapper.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import MoodMapKit

public struct MemoryLaneViewWrapper: View {
    @ObservedObject private var moodVM = MoodViewModel.shared

    public var body: some View {
        ZStack {
            MemoryLaneView(moodEntries: $moodVM.moodEntries)
                .onAppear {
                    Task {
                        await moodVM.getMoods()
                    }

                }
            if moodVM.isLoading {
                ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 100, height: 100)
            }
        }        .onAppear {

            DispatchQueue.main.async {
                Task {
                    do {
                        await  moodVM.getMoods()
                    }
                }

            }
        }

    }
}

// struct MemoryLaneViewWrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        let previewData = PlaceholderData()
//        MemoryLaneViewWrapper(moodEntries: Binding<[MoodEntry]>(
//            get: { previewData.moodEntries },
//            set: { previewData.moodEntries = $0 }
//        ))
//    }
// }
