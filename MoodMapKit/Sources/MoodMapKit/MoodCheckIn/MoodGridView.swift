//
//  MoodGridView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import CoreMotion

public func getMoodCategoryColorMine(for category: MoodCategory) -> AngularGradient {
    let baseColors: [Color]
    let startAngle: Angle
    let endAngle: Angle

    switch category {
    case .highEnergyUnpleasant:
        baseColors = [
            Color(hex: "#FF6B6B"), // Vibrant Red
            Color(hex: "#FFADAD"), // Lighter shade of red
            Color(hex: "#FFD6D6") // Even lighter shade of red
        ]
        startAngle = .degrees(-90)
        endAngle = .degrees(360)

    case .highEnergyPleasant:
        baseColors = [
            Color(hex: "#FFCC4D"), // Vibrant Yellow
            Color(hex: "#FFE698"), // Lighter shade of yellow
            Color(hex: "#FFF4CC") // Even lighter shade of yellow
        ]
        startAngle = .degrees(-90)
        endAngle = .degrees(360)

    case .lowEnergyPleasant:
        baseColors = [
            Color(hex: "#6AB7FF"), // Vibrant Blue
            Color(hex: "#A5D8FF"), // Lighter shade of blue
            Color(hex: "#D0E9FF") // Even lighter shade of blue
        ]
        startAngle = .degrees(-90)
        endAngle = .degrees(360)

    case .lowEnergyUnpleasant:
        baseColors = [
            Color(hex: "#A65FCA"), // Vibrant Purple
            Color(hex: "#D39EF3"), // Lighter shade of purple
            Color(hex: "#ECCAFF") // Even lighter shade of purple
        ]
        startAngle = .degrees(-90)
        endAngle = .degrees(360)
    }

    let colors = [Color.white] + baseColors
    let gradient = AngularGradient(gradient: Gradient(colors: colors), center: .center, startAngle: startAngle, endAngle: endAngle)

    return gradient
}

public func backgroundForCategory(_ category: MoodCategory) -> Color {
    switch category {
    case .highEnergyUnpleasant:
        return  Color(hex: "#FF6B6B")
    case .lowEnergyPleasant:
        return             Color(hex: "#6AB7FF")
    case .lowEnergyUnpleasant:
        return Color(hex: "#A65FCA")
    case .highEnergyPleasant:
        return Color(hex: "#FFCC4D")
    }
    // Add more cases for other categories as needed
}

/// A view that displays a grid of moods for selection.
///
/// Use `MoodGridView` to create a view that presents a grid of moods with selectable options.
/// The view supports scrolling in both horizontal and vertical directions.
public struct MoodGridView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingToast = false
    @State private var toastMessage = ""
    @Binding var moodSelected: Mood?
    var closeView: () -> Void
    var circleTappedAction: () -> Void

    /// The array of moods to display in the grid.
    var moods: [Mood]

    private static let gridSize: CGFloat = 200
    private static let spacingBetweenColumns: CGFloat = 4 // Adjust the spacing between columns as desired
    private static let spacingBetweenRows: CGFloat = 16
    @State private var previousOffset: CGFloat = 0

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
    public init(moodSelected: Binding<Mood?>, moods: [Mood], closeView: @escaping () -> Void, circleTappedAction: @escaping () -> Void) {
        self._moodSelected = moodSelected
        self.moods = moods
        self.closeView = closeView
        self.circleTappedAction = circleTappedAction
    }

    /// The body view of the MoodGridView.
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                    .ignoresSafeArea(.all)

                ZStack {
                    Color.clear
                        .ignoresSafeArea(.all)
                    ScrollViewReader { scrollViewProxy in
                        ScrollView([.horizontal, .vertical], showsIndicators: false) {
                            LazyVGrid(
                                columns: columns,
                                alignment: .center,
                                spacing: Self.spacingBetweenRows
                            ) {
                                ForEach(moods, id: \.self) { mood in
                                    Text("\(mood.name) \(mood.emoji)")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .background(getMoodCategoryColorMine(for: mood.category)
                                        )
                                        .cornerRadius(100)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                                        .shadow(color: Color.white.opacity(0.1), radius: 2, x: 0, y: 1)
                                        .onTapGesture {

                                            withAnimation {
                                                moodSelected = mood
                                                showMoodToast(message: mood.name)
                                            }
                                        }
                                        .offset(x: offsetX + offsetX(for: mood, geometry: geometry))
                                        .matchedGeometryEffect(id: mood.hashValue, in: scrollId)
                                }
                            }

                            .onChange(of: moods.count) { _ in
                                scrollViewProxy.scrollTo(moods.last?.hashValue, anchor: .bottomTrailing)
                            }
                            .background(
                                GeometryReader { geometry in
                                    let offset = geometry.frame(in: .named(scrollId)).origin.y
                                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: offset)
                                }
                                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                                    DispatchQueue.main.async {
                                        let isScrollingBack = offset < previousOffset

                                        if isScrollingBack {
                                            withAnimation {

                                                moodSelected = nil
                                            }
                                        }

                                        previousOffset = offset
                                    }
                                }
                            )

                        }

                    }

                }
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .scaledToFit()
                        .padding(8)
                        .background(Circle().fill(.ultraThinMaterial))
                        .foregroundColor(.accentColor)
                }

                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 20)
                .padding(.top, 20)
                if isShowingToast && moodSelected != nil {

                    ZStack {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text(moodSelected?.name ?? "Happy")
                                    .foregroundColor(backgroundForCategory(MoodCategory(rawValue: (moodSelected?.category)!.rawValue) ??                MoodCategory.highEnergyPleasant))
                                    .padding(.bottom, 1)
                                Text(moodSelected?.description ?? "Excepteur deserunt cupidatat laboris commodo duis eiusmod do et minim tempor est anim tempor consequat adipisicing.")
                            }.padding(.leading, 8)
                            Spacer()
                            Button {
                                circleTappedAction()
                            } label: {
                                Circle()
                                    .fill(.ultraThickMaterial)
                                    .frame(width: geometry.size.width/5, height: geometry.size.width/5)
                                    .overlay(
                                        Image(systemName: "arrow.right")
                                            .font(.title)
                                            .foregroundColor(backgroundForCategory(MoodCategory(rawValue: (moodSelected?.category)!.rawValue) ?? MoodCategory.highEnergyPleasant))
                                    )

                            }

                        }.frame(maxWidth: geometry.size.width * 0.9)
                        .font(.appSubheadline)
                        .padding()
                    }.foregroundColor(.primary)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 200))
                    .frame(maxWidth: geometry.size.width * 0.9, maxHeight: .infinity, alignment: .bottom)

                }
            }

        }.navigationBarHidden(true)

    }

    func offsetX(for mood: Mood, geometry: GeometryProxy) -> CGFloat {
        let index = moods.firstIndex(of: mood) ?? 0
        let columnCount = columns.count
        let rowNumber = index / columnCount

        let gridWidth = geometry.size.width * 0.8
        let columnWidth = gridWidth / CGFloat(columnCount)
        let spacingBetweenColumns = columnWidth / 4

        if rowNumber % 2 == 0 {
            return columnWidth/2.5 + spacingBetweenColumns
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
        MoodGridView(moodSelected: .constant(nil), moods: [], closeView: {}, circleTappedAction: {})
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func hapticFeedback(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) -> some View {
        self.modifier(HapticFeedbackModifier(feedbackType: feedbackType))
    }
}

struct HapticFeedbackModifier: ViewModifier {
    let feedbackType: UINotificationFeedbackGenerator.FeedbackType

    func body(content: Content) -> some View {
        content.onChange(of: true) { _ in
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
            feedback.notificationOccurred(feedbackType)
        }
    }
}
