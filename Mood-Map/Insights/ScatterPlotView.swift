//
//  ScatterPlotView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import SwiftUI
import MoodMapKit
import Charts

enum SelectedOption {
    case intensity
    case happiness

    var description: String {
        switch self {
        case .intensity:
            return "Intensity"
        case .happiness:
            return "Happiness"
        }
    }
}

public struct ScatterPlotView: View {
    @State private var isSheetPresented = false
    @ObservedObject var placeholder = PlaceholderData()
    @State private var selectedIndex: String?
    @State private var selectedWeekday: String = ""
    @State private var selectedIntensity: Double = 0.0
    @State private var moodEntries: [MoodEntry] = []
    @State private var displayFactor: LifeFactors?
    @State private var exerciseHours: [MoodInsightsData<Date, Double>] = []
    @State private var sleepHours: [MoodInsightsData<Date, Double>] = []
    @State private var selectedOption: SelectedOption = .intensity

    init(placeholder: PlaceholderData = PlaceholderData(), moodEntries: [MoodEntry]) {
        self.placeholder = placeholder
        self.moodEntries = moodEntries
    }

    /// The body view of the ScatterPlotView.
    public var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            // MARK: - MAIN PLOT
//            VStack {
//                Chart(moodEntries) { moodEntry in
//                    PointMark(
//                        x: .value("Day", moodEntry.date, unit: .weekday),
//                        y: .value("Pleasant Index", moodEntry.mood.happinessIndex)
//
//                    )
//                    .annotation(position: .overlay, alignment: .center) {
//                        ZStack {
//                            Circle()
//                                .fill(getMoodCategoryColor(for: moodEntry.mood.category))
//
//                        }.frame(width: 8, height: 8)
//                    }
//                    .symbolSize(0) // hide the existing symbol
//                    .foregroundStyle(by: .value("Mood", moodEntry.mood.category.rawValue))
//                    .symbol(by: .value("Mood", moodEntry.mood.category.rawValue))
//                    //                    .position(by: .value("Mood", moodEntry.mood.category.rawValue))
//                    .accessibilityLabel(moodEntry.date.description)
//                    .accessibilityValue(moodEntry.mood.category.rawValue)
//                }
//
//                .frame(height: 300)
//                .chartXScale(range: .plotDimension(padding: 8))
//            }
//            .chartXAxis {
//                AxisMarks(values: .stride(by: .day, count: 1)) { _ in
//                    AxisGridLine()
//                    AxisTick()
//                    AxisValueLabel(
//                        format: .dateTime.weekday(.abbreviated)
//                    )
//                }
//            }
//            .chartYAxis {
//
//                AxisMarks(
//                    preset: .automatic,
//                    position: .trailing,
//                    values: [0, 5, 10]
//                ) { value in
//                    AxisGridLine()
//                    AxisTick()
//                    AxisValueLabel(
//                        descriptionForUVIndex(value.as(Int.self)!)
//
//                    )
//                }
//            }
//            .chartXAxisLabel("Weeks", alignment: .top)
//            .chartLegend(position: .top, alignment: .leading, spacing: 8) {
//                HStack {
//
//                    MoodCategoryLegendView()
//
//                }
//            }
//            .chartOverlay { proxy in
//                GeometryReader { geometry in
//                    Rectangle().fill(.clear).contentShape(Rectangle())
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    // Convert the gesture location to the coordinate space of the plot area.
//                                    let origin = geometry[proxy.plotAreaFrame].origin
//                                    let location = CGPoint(
//                                        x: value.location.x - origin.x,
//                                        y: value.location.y - origin.y
//                                    )
//                                    // Get the x (weekday) and y (intensity) values from the location.
//                                    if let (weekday, intensity) = proxy.value(at: location, as: (String, Double).self) {
//                                        selectedWeekday = weekday
//                                        selectedIntensity = intensity
//                                    }
//                                }
//                        )
//                }
//            }
//            .padding()
//
//            if displayFactor == nil {
//                HStack {Image(systemName: "lightbulb.led.fill")
//                    .foregroundColor(.accentColor)
//                    Text("Understand above chart")
//                    Spacer()
//                    Image(systemName: "chevron.down")
//                        .foregroundColor(.primary)
//                }.padding()
//                .onTapGesture {
//                    isSheetPresented.toggle()
//                }
//                .font(.appBody)
//            }
//
//            // MARK: - DISPLAY FACTORS
//
//            // MARK: Sleep
//
//            if displayFactor == .sleep {
//                GroupBox(label: Text("Sleep Hours")) {
//                    Chart(sleepHours, id: \.self) { moodEntry in
//                        BarMark(
//                            x: .value("Day", moodEntry.key, unit: .day),
//                            y: .value("Happiness Index", moodEntry.value)
//                        )
//                        .foregroundStyle(
//                            .linearGradient(
//                                colors: [ .init(hex: "#80FF72"), .init(hex: "#7EE8FA")],
//                                startPoint: .bottom,
//                                endPoint: .top
//                            )
//                        )
//                    }
//                    //                .chartXAxis {
//                    //                    AxisMarks(values: .stride(by: .day, count: 1)) { _ in
//                    //                        AxisGridLine()
//                    //                        AxisTick()
//                    //                        AxisValueLabel(
//                    //                            format: .dateTime.weekday(.abbreviated)
//                    //                        )
//                    //                    }
//                    //
//                    //                }
//                    //                .chartYAxis {
//                    //
//                    //                    AxisMarks(
//                    //                        preset: .aligned,
//                    //                        position: .leading,
//                    //                        values: [10,,10]
//                    //                    ) { value in
//                    //                        AxisValueLabel(
//                    //                            "\(value.index.description) hours"
//                    //                        )
//                    //                    }
//                    //                }
//
//                }.padding()
//                .frame(height: 150)
//            }
//
//            // MARK: Exercise
//
//            if displayFactor == .exercise {
//
//                GroupBox(label: Text("Exercise Hours")) {
//                    Chart(exerciseHours, id: \.self) { moodEntry in
//
//                        BarMark(
//                            x: .value("Day", moodEntry.key, unit: .day),
//                            y: .value("Happiness Index", moodEntry.value)
//                        )                    .foregroundStyle(
//                            .linearGradient(
//                                colors: [ .init(hex: "#EC9F05"), .init(hex: "#FF4E00")],
//                                startPoint: .bottom,
//                                endPoint: .top
//                            )
//                        )
//
//                    }
//
//                    //                              .chartXAxis {
//                    //                    AxisMarks(values: .stride(by: .day, count: 1)) { _ in
//                    //                        AxisGridLine()
//                    //                        AxisTick()
//                    //                        AxisValueLabel(
//                    //                            format: .dateTime.weekday(.abbreviated)
//                    //                        )
//                    //                    }
//                    //                }
//
//                }.padding().frame(height: 150)
//            }
//
//            // MARK: Place
//
////            if displayFactor == .place {
////                GroupBox(label: Text("Place")) {
////                    Chart(moodEntries, id: \.self) { moodEntry in
////                        PointMark(
////                            x: .value("Day", moodEntry.date, unit: .day),
////                            y: .value("Place", moodEntry.place!)
////                        ).foregroundStyle(by: .value("Place", moodEntry.mood.category.rawValue))
////                        //                        .symbol(by:.value("Place", moodEntry.place!))
////                        .foregroundStyle(
////                            .linearGradient(
////                                colors: [ .init(hex: "#80FF72"), .init(hex: "#7EE8FA")],
////                                startPoint: .bottom,
////                                endPoint: .top
////                            )
////                        )
////                    }
////
////                }.padding().frame(height: 250)
////            }
//
//            // MARK: Weather
//
////            if displayFactor == .weather.displayName {
////                GroupBox(label: Text("Weather")) {
////                    Chart(moodEntries, id: \.self) { moodEntry in
////                        PointMark(
////                            x: .value("Day", moodEntry.date, unit: .day),
////                            y: .value("Happiness Index", moodEntry.weather!)
////                        ).foregroundStyle(by: .value("Weather", moodEntry.weather!))
////                        .symbol(by: .value("Weather", moodEntry.weather!))
////                        .foregroundStyle(
////                            .linearGradient(
////                                colors: [ .init(hex: "#80FF72"), .init(hex: "#7EE8FA")],
////                                startPoint: .bottom,
////                                endPoint: .top
////                            )
////                        )
////                    }
////
////                }.padding().frame(height: 250)
////            }
//
//            // MARK: Display Factor Buttons
//
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Life Factors")
//                    .font(.appTitle3)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.vertical)
//
//                ForEach(LifeFactors.allCases, id: \.id) { factor in
//                    LifeFactorButton(lifeFactor: factor, averageHours: "6h 32 mins", totalHours: "06 - 08 hrs", displayFactor: $displayFactor)
//                }
//
//            }.padding()
//            .background(.ultraThinMaterial)
//
//        }.onAppear(perform: {
//            moodEntries = placeholder.moodEntries
//            print(moodEntries.count)
//            exerciseHours = MoodInsights.getExerciseHours(from: moodEntries)
//            sleepHours = MoodInsights.getExerciseHours(from: moodEntries)
//        })
//        .navigationTitle("Mood Analysis")
//        .sheet(isPresented: $isSheetPresented) {
//            ModalSheetView(showSheetView: $isSheetPresented)
//        }

        Text("Wait until the fix")
    }

    func descriptionForUVIndex(_ index: Int) -> String {
        switch index {
        case 0: return "Very Unpleasant"
        case 5: return "Neutral"
        case 10: return "Very Pleasant"
        default: return "Extreme"
        }
    }
}

func getMoodCategoryColor(for category: MoodCategory) -> Color {
    switch category {
    case .highEnergyPleasant:
        return Color(hex: "#FF6B6B") // Vibrant Red
    case .highEnergyUnpleasant:
        return Color(hex: "#FFCC4D") // Vibrant Yellow
    case .lowEnergyPleasant:
        return Color(hex: "#6AB7FF") // Vibrant Blue
    case .lowEnergyUnpleasant:
        return Color(hex: "#A65FCA") // Vibrant Purple
    }
}

struct ScatterPlotView_Previews: PreviewProvider {
    static var previews: some View {
        ScatterPlotView(moodEntries: [])
    }
}

public struct ExpandedView<Content: View>: View {
    @State private var showMore = false
    private let title: String
    private let expandedContent: Content

    public init(title: String, @ViewBuilder expandedContent: () -> Content) {
        self.title = title
        self.expandedContent = expandedContent()
    }

    public var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: showMore ? "chevron.up" : "chevron.down")
                }
                .padding(.horizontal)
                .padding(.bottom)
                .onTapGesture {
                    withAnimation {
                        showMore.toggle()
                    }
                }

                if showMore {
                    expandedContent
                        .font(.appCaption)
                        .foregroundColor(.secondary)
                        .transition(.opacity) // Apply fade animation
                }
            }
        }
    }
}

struct CategorySymbol: ChartSymbolShape {
    var perceptualUnitRect: CGRect = .zero

    func path(in rect: CGRect) -> Path {
        .init()
    }
}

struct MoodCategoryLegendView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        LazyVGrid(columns: columns, alignment: .leading, spacing: 4) {
            createMoodCell(for: .highEnergyPleasant, color: Color.red)
            createMoodCell(for: .highEnergyUnpleasant, color: Color.yellow)
            createMoodCell(for: .lowEnergyPleasant, color: Color.blue)
            createMoodCell(for: .lowEnergyUnpleasant, color: Color.purple)
        }
        .padding(8)
    }

    func createMoodCell(for category: MoodCategory, color: Color) -> some View {
        HStack {
            Circle()
                .fill(getMoodCategoryColor(for: category))
                .frame(width: 8, height: 8)
            Text(category.rawValue)
                .font(.appCaption)
                .foregroundColor(getMoodCategoryColor(for: category))

        }.padding(4)
        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(getMoodCategoryColor(for: category).opacity(0.2)))
    }
}

// MARK: - Modal Sheet View

struct ModalSheetView: View {
    @Binding var showSheetView: Bool

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                Text("""
        In a more detailed analysis of mood, it's often helpful to categorize moods beyond just "positive" or "negative". To achieve this, we could look at two key dimensions - energy level and pleasantness. The `MoodCategory` enum defined [here](https://www.example.com/mood-category-enum) provides four categories based on these dimensions:

        **[High Energy Pleasant (HEP)](https://www.example.com/mood-category-enu):** This category includes moods that are both energetic and positive. They can be described as active, alert, or excited states. Examples could include feeling enthusiastic, joyful, or confident.

        **[High Energy Unpleasant (HEU)](https://www.example.com/mood-category-enu):** This category includes moods that are high in energy but negative in nature. They typically correspond to agitated states such as feeling stressed, anxious, or angry.

        **[Low Energy Pleasant (LEP)](https://www.example.com/mood-category-enu):** This category is for moods that are positive yet passive or calm. Examples could include feeling relaxed, content, or peaceful.

        **[Low Energy Unpleasant (LEU)](https://www.example.com/mood-category-enu):** This category includes moods that are low in energy and negative, corresponding to states such as feeling sad, tired, or depressed.

        These categories can provide a more nuanced understanding of a person's emotional state and its fluctuations. It might reveal, for example, that a person often swings between high-energy states, both pleasant (**HEP**) and unpleasant (**HEU**), or that they tend to stay in a low-energy state, whether it's pleasant (**LEP**) or unpleasant (**LEU**).

        When it comes to correlations with life factors, these categories might also reveal more nuanced relationships. For instance, [high stress](https://www.example.com/stress-and-mood) might correlate more with high-energy states, whether pleasant or unpleasant, while lack of sleep might correlate more with low-energy states.

            Please note that mood categorization can be highly subjective and can vary based on individual interpretations and cultural factors. These categories should be used as a guideline and not a definitive classification. They're best used in combination with other [mood analysis tools and methodologies](https://www.example.com/mood-analysis-tools).
    """)
                    .font(.appBody)
                    .multilineTextAlignment(.leading)
            }.padding(.horizontal)
            //                .navigationBarTitle(Text("Understanding Mood Map"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showSheetView = false
            }) {
                Text("Done").font(.appBody)
            })
        }

    }
}
