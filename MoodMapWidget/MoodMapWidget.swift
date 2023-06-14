//
//  MoodMapWidget.swift
//  MoodMapWidget
//
//  Created by Ranga Reddy Nukala on 14/06/23.
//

import WidgetKit
import SwiftUI
import Intents

import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

func randomImage() -> String {
    var strings: [String] = []
    for number in 1...100 {
        let formattedNumber = String(format: "%03d", number)
        strings.append(formattedNumber)
    }
    return strings.randomElement() ?? "024"
}

struct MoodMapWidgetEntryView : View {
    @Environment(\.colorScheme) var colorScheme

    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack {
                Text("What emotions are you experiencing right now?")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("032")
                .opacity(colorScheme == .dark ? 0.9 : 0.3)
            )
            .padding()
        }
    }
    
    
    func getRandomMoodEntryPrompt() -> String {
        let moodEntryPrompts = [
            "How are you feeling today?",
            "Describe your current mood.",
            "What emotions are you experiencing right now?",
            "Share your mood for today.",
            "Reflect on your feelings at this moment.",
            "Record your mood for the day.",
            "What made you happy today?",
            "Is there anything bothering you?",
            "What's been on your mind lately?",
            "What activities have you enjoyed recently?",
            "How would you rate your energy level today?",
            "Did anything exciting or memorable happen today?",
            "Have you noticed any patterns in your moods lately?",
            "Are there any specific triggers for your current mood?",
            "What strategies have you used to manage your mood?",
            "What self-care activities have you practiced today?",
            "Are there any goals or intentions you have for your mood?",
            "What are you grateful for today?",
            "How can you improve your mood in the next few days?",
            "What support or resources do you need for your mood?",
            "Reflect on the positive moments from today.",
            "Are there any areas of your life that are impacting your mood?",
            "How does your mood affect your daily activities?",
            "What strategies have worked well for you in the past?",
            "Is there anything you want to change about your current mood?",
            "What do you hope to achieve with your mood tracking?",
        ]

        return moodEntryPrompts.randomElement() ?? ""
    }
}



struct MoodMapWidget: Widget {
    let kind: String = "MoodMapWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MoodMapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge]) // Add supported widget families
    }
}

struct MoodMapWidget_Previews: PreviewProvider {
    static var previews: some View {

            MoodMapWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

