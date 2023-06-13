//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import Foundation

// public struct MoodInsights {

//    public static func generateHeatmapData(moods: [MoodEntry], factor: MoodFactor) -> [[Double]] {
//        var heatmapData: [[Double]] = Array(repeating: Array(repeating: 0.0, count: 24), count: 7)
//        var countByTime: [Int: Int] = [:]
//        var selectedFactorValues: Set<String> = Set()
//
//        for moodEntry in moods {
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.weekday, .hour], from: moodEntry.timestamp)
//
//            if let weekday = components.weekday, let hour = components.hour {
//                let factorValue: String
//
//                switch factor {
//                    case .place:
//                    factorValue = moodEntry.place?.rawValue ?? "Unknown"
//                    case .exerciseHours:
//                        factorValue = moodEntry.exerciseHours != nil ? "\(moodEntry.exerciseHours!) hours" : "Unknown"
//                    case .sleepHours:
//                        factorValue = moodEntry.sleepHours != nil ? "\(moodEntry.sleepHours!) hours" : "Unknown"
//                    case .weather:
//                        factorValue = moodEntry.weather?.rawValue ?? "Unknown"
//                }
//
//                selectedFactorValues.insert(factorValue)
//
//                let timeInterval = weekday * 100 + hour
//                countByTime[timeInterval, default: 0] += 1
//                heatmapData[weekday - 1][hour] += Double(moodEntry.moods.first?.toMood().intensityLevel)
//            }
//        }
//
//        let factorValues = Array(selectedFactorValues)
//
//        for weekday in 0..<7 {
//            for hour in 0..<24 {
//                let timeInterval = weekday * 100 + hour
//                let count = countByTime[timeInterval, default: 1]
//                heatmapData[weekday][hour] /= Double(count)
//            }
//        }
//
//        return heatmapData
//    }
//
//    public static func generateBarChartData(moods: [MoodEntry], factor: MoodFactor) -> [String: Int] {
//        var barChartData: [String: Int] = [:]
//
//        for moodEntry in moods {
//            let factorValue: String
//
//            switch factor {
//                case .place:
//                    factorValue = moodEntry.place?.rawValue ?? "Unknown"
//                case .exerciseHours:
//                    factorValue = moodEntry.exerciseHours != nil ? "\(moodEntry.exerciseHours!) hours" : "Unknown"
//                case .sleepHours:
//                    factorValue = moodEntry.sleepHours != nil ? "\(moodEntry.sleepHours!) hours" : "Unknown"
//                case .weather:
//                    factorValue = moodEntry.weather?.rawValue ?? "Unknown"
//            }
//
//            barChartData[factorValue, default: 0] += 1
//        }
//
//        return barChartData
//    }
//
//    public static func generateLineGraphData(moods: [MoodEntry]) -> [(Date, Double)] {
//        var lineGraphData: [(Date, Double)] = []
//
//        for moodEntry in moods {
//            let dataPoint: (Date, Double) = (moodEntry.timestamp, Double(moodEntry.moods.first?.toMood().intensityLevel))
//            lineGraphData.append(dataPoint)
//        }
//
//        return lineGraphData
//    }
//
//    public static func generateScatterPlotData(moods: [MoodEntry]) -> [(Double, Double)] {
//        var scatterPlotData: [(Double, Double)] = []
//
//        for moodEntry in moods {
//            let dataPoint: (Double, Double) = (moodEntry.moods.first?.toMood().happinessIndex, Double(moodEntry.moods.first?.toMood().intensityLevel))
//            scatterPlotData.append(dataPoint)
//        }
//
//        return scatterPlotData
//    }
// }

public enum MoodFactor {
    case place
    case exerciseHours
    case sleepHours
    case weather
}

public struct MoodInsightsData<Key: Hashable, Value: Hashable>: Hashable {
    public let key: Key
    public let value: Value

    public init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}

public class MoodInsights {
    let moodEntries: [MoodEntry]

    public init(moodEntries: [MoodEntry]) {
        self.moodEntries = moodEntries
    }

    public static func getExerciseHours(from moodEntries: [MoodEntry]) -> [MoodInsightsData<Date, Double>] {
        var maxExerciseHoursByDate: [Date: Double] = [:]

        for moodEntry in moodEntries {
            guard let exerciseHours = moodEntry.exerciseHours else {
                continue
            }

            let date = moodEntry.date

            if let existingMaxHours = maxExerciseHoursByDate[date] {
                maxExerciseHoursByDate[date] = max(existingMaxHours, Double(exerciseHours))
            } else {
                maxExerciseHoursByDate[date] = Double(exerciseHours)
            }
        }

        let exerciseHoursData = maxExerciseHoursByDate.map { MoodInsightsData(key: $0.key, value: $0.value) }
        return exerciseHoursData
    }

    public static func getSleepHours(from moodEntries: [MoodEntry]) -> [MoodInsightsData<Date, Double>] {
        var maxSleepHoursByDate: [Date: Double] = [:]

        for moodEntry in moodEntries {
            guard let sleepHours = moodEntry.sleepHours else {
                continue
            }

            let date = moodEntry.date

            if let existingMaxHours = maxSleepHoursByDate[date] {
                maxSleepHoursByDate[date] = max(existingMaxHours, Double(sleepHours))
            } else {
                maxSleepHoursByDate[date] = Double(sleepHours)
            }
        }

        let sleepHoursData = maxSleepHoursByDate.map { MoodInsightsData(key: $0.key, value: $0.value) }
        return sleepHoursData
    }

    public static func getAverageExerciseHoursMetrics(from moodEntries: [MoodEntry]) -> [String: Double]? {
        let exerciseHours = moodEntries.compactMap { $0.exerciseHours }
        guard !exerciseHours.isEmpty else {
            return nil
        }

        let totalExerciseHours = exerciseHours.reduce(0, +)
        let averageExerciseHours = Double(totalExerciseHours) / Double(exerciseHours.count)

        return [
            "averageExerciseHours": averageExerciseHours,
            "totalExerciseHours": Double(totalExerciseHours)
        ]
    }

    public static func getAverageSleepHoursMetrics(from moodEntries: [MoodEntry]) -> [String: Double]? {
        let sleepHours = moodEntries.compactMap { $0.sleepHours }
        guard !sleepHours.isEmpty else {
            return nil
        }

        let totalSleepHours = sleepHours.reduce(0, +)
        let averageSleepHours = Double(totalSleepHours) / Double(sleepHours.count)

        return [
            "averageSleepHours": averageSleepHours,
            "totalSleepHours": Double(totalSleepHours)
        ]
    }
}
