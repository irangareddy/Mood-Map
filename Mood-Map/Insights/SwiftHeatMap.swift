//
//  SwiftHeatMap.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 04/06/23.
//

import SwiftUI
import MoodMapKit
import Charts

enum Interval: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case allTime = "All-Time"
}

struct SwiftHeatMap: View {
    private let intervals = Interval.allCases
    private let months = Calendar.current.monthSymbols
    private let years = (2020...Calendar.current.component(.year, from: Date())).map { String($0) }

    @State private var selectedInterval = Interval.week
    @State private var isPickerShown = false
    @State private var selectedValue = ""

    private let startYear = 2022
    private let endYear = 2023

    @State private var selectedWeekIndex = 0
    private var weekList: [String] {
        WeekListGenerator.generateWeekList(startYear: startYear)
    }

    var body: some View {

        VStack {
            IntervalPicker(selectedInterval: $selectedInterval, intervals: intervals)

            HStack {
                SelectedValueView(selectedValue: selectedValue.currentOrLastWeek)
                    .onTapGesture {
                        isPickerShown = true
                    }
                Spacer()
            }
            .padding(.horizontal)

            #warning ("Create a Heat Map")

            Spacer()

        }
        .sheet(isPresented: $isPickerShown, content: {
            PickerSheetView(selectedInterval: selectedInterval, selectedValue: $selectedValue, weekList: weekList, months: months, years: years)
        })
        .navigationTitle("Heat Map")
        .onAppear {
            selectedValue = weekList[selectedWeekIndex]
        }
        .onChange(of: selectedInterval) { interval in
            switch interval {
            case .week:
                selectedValue = weekList[selectedWeekIndex]
            case .month:
                selectedValue = "\(months[0]) \(years[0])"
            case .year:
                selectedValue = years[0]
            case .allTime:
                selectedValue = years[0]
            }
        }
    }
}

struct IntervalPicker: View {
    @Binding var selectedInterval: Interval

    let intervals: [Interval]

    var body: some View {
        Picker("Time Interval", selection: $selectedInterval) {
            ForEach(intervals, id: \.self) { interval in
                Text(interval.rawValue)
                    .tag(interval)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

struct SelectedValueView: View {
    let selectedValue: String

    var body: some View {
        HStack(spacing: 10) {
            Text(selectedValue)
                .font(.appSubheadline)

            Image(systemName: "chevron.down")
                .font(.subheadline)
        }
        .foregroundColor(.accentColor)
    }
}

struct PickerSheetView: View {
    let selectedInterval: Interval
    @Binding var selectedValue: String

    let weekList: [String]
    let months: [String]
    let years: [String]

    var body: some View {
        VStack {
            switch selectedInterval {
            case .week:
                WeekPicker(selectedWeekIndex: $selectedValue, weekList: weekList)
            case .month:
                MonthPicker(selectedMonthIndex: $selectedValue, months: months, selectedYearIndex: $selectedValue, years: years)
            case .year:
                YearPicker(selectedValue: $selectedValue, years: years)
            case .allTime:
                YearPicker(selectedValue: $selectedValue, years: years)
            }
        }
        .presentationDetents([.medium])
    }
}

struct WeekPicker: View {
    @Binding var selectedWeekIndex: String
    let weekList: [String]

    var body: some View {
        Picker(selection: $selectedWeekIndex, label: Text("Week")) {
            ForEach(0..<weekList.count, id: \.self) { index in
                Text(weekList[index])
                    .font(.appBody)
                    .tag(index)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(height: 200)
    }
}

struct MonthPicker: View {
    @Binding var selectedMonthIndex: String
    let months: [String]
    @Binding var selectedYearIndex: String
    let years: [String]

    var body: some View {
        HStack {
            Picker("Month", selection: $selectedMonthIndex) {
                ForEach(0..<months.count, id: \.self) { index in
                    Text(months[index])
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 150)

            Picker("Year", selection: $selectedYearIndex) {
                ForEach(0..<years.count, id: \.self) { index in
                    Text(years[index])
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
        }
    }
}

struct YearPicker: View {
    @Binding var selectedValue: String
    let years: [String]

    var body: some View {
        Picker("Year", selection: $selectedValue) {
            ForEach(years, id: \.self) { year in
                Text(year)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(height: 100)
    }
}

struct SwiftHeatMap_Previews: PreviewProvider {
    static var previews: some View {
        SwiftHeatMap()
    }
}
