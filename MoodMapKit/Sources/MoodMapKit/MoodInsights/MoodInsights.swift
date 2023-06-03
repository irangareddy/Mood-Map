//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import Foundation

public struct MoodInsights {

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
    //                heatmapData[weekday - 1][hour] += Double(moodEntry.mood.intensityLevel)
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
    //            let dataPoint: (Date, Double) = (moodEntry.timestamp, Double(moodEntry.mood.intensityLevel))
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
    //            let dataPoint: (Double, Double) = (moodEntry.mood.happinessIndex, Double(moodEntry.mood.intensityLevel))
    //            scatterPlotData.append(dataPoint)
    //        }
    //
    //        return scatterPlotData
    //    }
}

public enum MoodFactor {
    case place
    case exerciseHours
    case sleepHours
    case weather
}
