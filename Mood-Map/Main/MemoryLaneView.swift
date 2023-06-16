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
    @ObservedObject var moodViewModel = MoodViewModel.shared
    @Binding var moodEntries: [AppwriteModels.Document<MoodEntry>]
    @State var searchText = ""
    @GestureState var isDragging: Bool = false
    @State var offsetY: CGFloat = 0
    @State var timeOut = 0.3
    @State var currentMoodEntry: ScrollMood = ScrollMood(id: UUID(), date: Date(), moods: [], index: 0)
    @State var groupedMoodEntries: [ScrollMood] = []
    @State var currentActiveIndex: Int = 0
    @State var currentItem: AppwriteModels.Document<MoodEntry>?
    @State var showDetail = false

    public init(moodEntries: Binding<[AppwriteModels.Document<MoodEntry>]>) {
        _moodEntries = moodEntries
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
                .onAppear(perform: {
                    Task {
                        do {
                            await moodViewModel.getMoods()
                            updateGroupedMoodEntries()
                        }
                    }
                })
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
            }
            .navigationTitle("Memory Lane")
        }
        .overlay(alignment: .trailing) {
            VStack(alignment: .trailing) {
                Text("2023")
                    .font(.caption)
                    .padding(.trailing, 4)
                CustomScroller()
            }
            .padding(.top, 35)
        }
        .onAppear {
            if groupedMoodEntries.isEmpty { // Check if grouped entries are already available
                DispatchQueue.main.async {
                    moodViewModel.updateLoading(true)
                }
            }
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                // Generate grouped entries only if they are not already available
                if groupedMoodEntries.isEmpty {
                    updateGroupedMoodEntries()
                }
                DispatchQueue.main.async {
                    moodViewModel.updateLoading(false)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                dateElevation()
            }
        }
        .overlay(
            Group {
                if moodViewModel.isLoading {
                    ProgressView() // Show the progress view while loading
                }
            }
        )
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
