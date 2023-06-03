//
//  MoodGridView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import CoreMotion

public func backgroundForCategory(_ category: MoodCategory) -> Color {
    switch category {
    case .highEnergyUnpleasant:
        return Color(red: 0.6, green: 0.8, blue: 0.6) // Subtle green for dark mode
    case .lowEnergyPleasant:
        return Color(red: 0.6, green: 0.6, blue: 0.8) // Subtle blue for dark mode
    case .lowEnergyUnpleasant:
        return Color(red: 0.8, green: 0.6, blue: 0.6) // Subtle red for dark mode
    case .highEnergyPleasant:
        return Color(red: 0.8, green: 0.8, blue: 0.6) // Subtle yellow for dark mode
    }
    // Add more cases for other categories as needed
}

/// A view that displays a grid of moods for selection.
///
/// Use `MoodGridView` to create a view that presents a grid of moods with selectable options.
/// The view supports scrolling in both horizontal and vertical directions.
public struct MoodGridView: View {
    @State private var isShowingToast = false
    @State private var toastMessage = ""
    @Binding var moodSelected: Mood?

    /// The array of moods to display in the grid.
    var moods: [Mood]

    private static let gridSize: CGFloat = 200
    private static let spacingBetweenColumns: CGFloat = 4 // Adjust the spacing between columns as desired
    private static let spacingBetweenRows: CGFloat = 16

    private let columns: [GridItem] = Array(
        repeating: .init(
            .fixed(gridSize),
            spacing: spacingBetweenColumns,
            alignment: .center
        ),
        count: 4
    )

    @State private var offsetX: CGFloat = 0
    @Namespace private var scrollId

    /// Initializes a `MoodGridView` with the given mood selection binding and array of moods.
    ///
    /// - Parameters:
    ///   - moodSelected: A binding to the currently selected mood.
    ///   - moods: The array of moods to display in the grid.
    public init(moodSelected: Binding<Mood?>, moods: [Mood]) {
        self._moodSelected = moodSelected
        self.moods = moods
    }

    /// The body view of the MoodGridView.
    public var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView([.horizontal, .vertical], showsIndicators: true) {
                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: Self.spacingBetweenRows
                        ) {
                            ForEach(moods, id: \.self) { mood in
                                Text("\(mood.name) \(mood.emoji)")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 100)
                                            .foregroundColor(backgroundForCategory(mood.category))
                                            .cornerRadius(8)
                                    )
                                    .onTapGesture {
                                        withAnimation {
                                            moodSelected = mood
                                            showMoodToast(message: mood.name)
                                        }
                                    }
                                    .offset(x: offsetX + offsetX(for: mood))
                                    .matchedGeometryEffect(id: mood.hashValue, in: scrollId)
                            }
                        }
                        .onChange(of: moods.count) { _ in
                            scrollViewProxy.scrollTo(moods.last?.hashValue, anchor: .bottomTrailing)
                        }
                        .background(
                            GeometryReader { geometry in
                                let offset = geometry.frame(in: .named(scrollId)).origin
                                Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: offset.x)
                            }
                        )
                    }
                }

                if isShowingToast && moodSelected != nil {
                    Text(moodSelected?.description ?? "Irure sint quis Lorem laborum. Culpa laborum voluptate aute nulla ad laboris. Aliquip aliquip occaecat eiusmod. Excepteur deserunt cupidatat laboris commodo duis eiusmod do et minim tempor est anim tempor consequat adipisicing.")
                        .font(.appBody)
                        .foregroundColor(.white)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 200)
                                .foregroundColor(Color.yellow.opacity(0.8))
                        )
                        .alert(isPresented: $isShowingToast) {
                            Alert(title: Text("Toast"), message: Text(toastMessage), dismissButton: .default(Text("OK")))
                        }
                }
            }
        }
    }

    func offsetX(for mood: Mood) -> CGFloat {
        let index = moods.firstIndex(of: mood) ?? 0
        let rowNumber = index / columns.count

        if rowNumber % 2 == 0 {
            return Self.gridSize/2 + Self.spacingBetweenRows/5
        }

        return 0
    }

    func showMoodToast(message: String) {
        toastMessage = message
        isShowingToast = true
    }
}

struct MoodGridView_Previews: PreviewProvider {
    static var previews: some View {
        MoodGridView(moodSelected: .constant(nil), moods: [])
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
