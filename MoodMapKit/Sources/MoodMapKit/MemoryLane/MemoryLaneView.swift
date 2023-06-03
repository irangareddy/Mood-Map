//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

public struct MemoryLaneView: View {
    @Binding var moodEntries: [MoodEntry]
    @State var searchText = ""
    @GestureState var isDragging: Bool = false
    @State var offsetY: CGFloat = 0
    @State var timeOut = 0.3
    @State var currentMoodEntry: ScrollMood = ScrollMood(id: UUID(), date: Date(), moods: [], index: 0)
    @State var groupedMoodEntries: [ScrollMood]  // Declare as @State
    @State var currentActiveIndex: Int = 0

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()

    public init(moodEntries: Binding<[MoodEntry]>) {
        _moodEntries = moodEntries
        _groupedMoodEntries = State(initialValue: [])
    }

    public var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(groupedMoodEntries) { scrollMood in
                            MoodEntryCardView(scrollMood: scrollMood)
                                .id(scrollMood.id)
                                .onAppear {
                                    if scrollMood.isCurrent {
                                        DispatchQueue.main.async {
                                            currentActiveIndex = scrollMood.index
                                            proxy.scrollTo(scrollMood.id, anchor: .top)
                                        }
                                    }
                                }

                        }
                    }
                    .padding(.top, 15)
                    .padding(.trailing, 120)
                }
                .onChange(of: currentActiveIndex) { newValue in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        proxy.scrollTo(groupedMoodEntries[newValue].id, anchor: .top)
                    }
                }
            }.navigationTitle("Memory Lane")
        }
        .overlay(alignment: .trailing) {
            VStack(alignment: .trailing) {
                Text("2023")
                    .font(.caption)
                CustomScroller()

            } .padding(.top, 35)
        }
        .onAppear {
            updateGroupedMoodEntries()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                dateElevation()
            }
        }
    }

    private func updateGroupedMoodEntries() {
        groupedMoodEntries = moodEntries.reduce(into: [Date: [MoodEntry]]()) { result, entry in
            let date = Calendar.current.startOfDay(for: entry.date)
            result[date, default: []].append(entry)
        }
        .enumerated()
        .map { index, keyValue in
            let (date, moodEntries) = keyValue
            return ScrollMood(id: UUID(), date: date, moods: moodEntries, index: index)
        }
        .sorted { $0.date > $1.date }
    }
}
