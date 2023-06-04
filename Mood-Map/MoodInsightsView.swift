//
//  MoodInsightsView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import MoodMapKit

// MARK: - InsightsCategory

enum InsightsCategory {
    case heatMap
    case trends
    case activity
    case patterns
    
    var cardName: String {
        switch self {
        case .heatMap:
            return "Heat Map"
        case .trends:
            return "Mood Distribution"
        case .activity:
            return "Mood Correlation"
        case .patterns:
            return "Mood Analysis"
        }
    }
    
    var title: String {
        switch self {
        case .heatMap:
            return "Heat Map"
        case .trends:
            return "Mood Distribution"
        case .activity:
            return "Mood Correlation"
        case .patterns:
            return "Mood Analysis"
        }
    }
    
    var description: String {
        switch self {
        case .heatMap:
            return "Gain Insight into Your Check-in History and Activity Consistency Over Time"
        case .trends:
            return "Explore Trends and Patterns in Your Emotions"
        case .activity:
            return "Track and Monitor Your Mood-related Activities"
        case .patterns:
            return "Discover Patterns and Correlations in Your Emotions"
        }
    }
    
    var randomStreakString: String {
        switch self {
        case .heatMap:
            return getRandomStreakString(days: 11)
        case .trends:
            return getRandomStreakString(days: nil)
        case .activity:
            return getRandomStreakString(days: 56)
        case .patterns:
            return getRandomStreakString(days: nil)
        }
    }
    
    var destination: AnyView {
        switch self {
        case .heatMap:
            return AnyView(DetailedView(title: self.cardName))
        case .trends:
            return AnyView(DetailedView(title: self.cardName))
        case .activity:
            return AnyView(DetailedView(title: self.cardName))
        case .patterns:
            return AnyView(DetailedView(title: self.cardName))
        }
    }
}

// MARK: - MoodInsightsView

struct MoodInsightsView: View {
    let cardInfos: [InsightsCategory] = [.heatMap, .trends, .activity, .patterns]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(cardInfos, id: \.self) { cardInfo in
                        MoodInsightsCard(
                            title: cardInfo.title,
                            description: cardInfo.description,
                            randomStreakString: cardInfo.randomStreakString,
                            content: {
                                // Additional content for the component
                                // Add any views you want to include here
                                // For example:
                                // Text("Card: \(cardInfo.cardName)")
                            },
                            destination: { cardInfo.destination }
                        )
                    }
                    .padding(.top)
                }
                .frame(maxWidth: .infinity)
                .navigationTitle("Mood Insights")
            }
        }
    }
}

// MARK: - MoodInsightsCard

struct MoodInsightsCard<Content: View>: View {
    let title: String
    let description: String
    let randomStreakString: String
    let content: Content
    let destination: () -> AnyView

    init(title: String, description: String, randomStreakString: String, @ViewBuilder content: () -> Content, destination: @escaping () -> AnyView) {
        self.title = title
        self.description = description
        self.randomStreakString = randomStreakString
        self.content = content()
        self.destination = destination
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            NavigationLink(
                destination: destination(),
                label: {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(title)
                                .font(.appTitle3)
                            .padding(.bottom, 8)
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()

                        Image(systemName: "arrow.right")
                            .padding(.trailing, 4)
                    }
                })



            Text(randomStreakString)
                .padding(.vertical)
                .font(.appBody)

            content

            Divider()
                .padding(.top)
        }
        .padding(.horizontal)
    }
}


// MARK: - DetailedView

struct DetailedView: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.appTitle)
    }
}

struct MoodInsightsView_Previews: PreviewProvider {
    static var previews: some View {
        MoodInsightsView()
    }
}

// FIXME: Clear Later

struct MoodInsightsSecondView: View {
    @State private var selectedChartIndex = 0
    let monthlyData: [[Double]] = [
        [0.2, 0.3, 0.5, 0.7, 0.9, 0.4, 0.2, 0.1, 0.3, 0.6, 0.8, 0.9],
        [0.1, 0.5, 0.2, 0.8, 0.6, 0.4, 0.7, 0.3, 0.5, 0.9, 0.2, 0.1],
        [0.7, 0.3, 0.4, 0.9, 0.6, 0.8, 0.5, 0.2, 0.1, 0.3, 0.5, 0.7],
        [0.5, 0.9, 0.2, 0.4, 0.1, 0.7, 0.6, 0.8, 0.3, 0.5, 0.9, 0.2],
        [0.6, 0.3, 0.9, 0.5, 0.7, 0.2, 0.8, 0.1, 0.3, 0.5, 0.9, 0.4],
        [0.8, 0.4, 0.5, 0.1, 0.9, 0.3, 0.2, 0.5, 0.7, 0.6, 0.8, 0.1]
    ]

    var body: some View {
        VStack {
            Picker(selection: $selectedChartIndex, label: Text("Select Chart")) {
                Text("Heat Map").tag(0)
                Text("Mood Distribution").tag(1)
                Text("Activity and Mood").tag(2)
                Text("Weather and Mood").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Spacer()

            if selectedChartIndex == 0 {
                HeatMapView(grid: HeatMapGrid(rows: monthlyData.count, columns: monthlyData[0].count, data: monthlyData))
            } else if selectedChartIndex == 1 {
                //                MoodDistributionView()
            } else if selectedChartIndex == 2 {
                //                MoodTrendsView()
            } else if selectedChartIndex == 3 {
                //                ScatterPlotView()
            }

            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .navigationTitle("Insights")
    }
}
