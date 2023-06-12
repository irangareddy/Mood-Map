//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import MoodMapKit
import SwiftUI
import AppwriteModels

public struct MemoryLaneView: View {
    @Binding var moodEntries: [AppwriteModels.Document<MoodEntry>]
    @State var searchText = ""
    @GestureState var isDragging: Bool = false
    @State var offsetY: CGFloat = 0
    @State var timeOut = 0.3
    @State var currentMoodEntry: ScrollMood = ScrollMood(id: UUID(), date: Date(), moods: [], index: 0)
    @State var groupedMoodEntries: [ScrollMood]  // Declare as @State
    @State var currentActiveIndex: Int = 0
    @State var currentItem: AppwriteModels.Document<MoodEntry>?
    @State var showDetail = false

    public init(moodEntries: Binding<[AppwriteModels.Document<MoodEntry>]>) {
        _moodEntries = moodEntries
        _groupedMoodEntries = State(initialValue: [])
    }

    public var body: some View {
        GeometryReader { _ in
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
                .sheet(isPresented: $showDetail, content: {
                    if let entry = currentItem?.data {
                        MoodEntryDetailView(moodEntry: entry)
                    }

                })
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
        groupedMoodEntries = moodEntries.reduce(into: [Date: [AppwriteModels.Document<MoodEntry>]]()) { result, entry in
            let date = Calendar.current.startOfDay(for: entry.data.date)
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

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

extension View {
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }

        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }

        return safeArea
    }
}
