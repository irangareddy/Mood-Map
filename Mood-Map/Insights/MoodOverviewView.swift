//
//  MoodOverviewView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 04/06/23.
//

import SwiftUI
import MoodMapKit

struct MoodOverviewView: View {
    var body: some View {

        // TODO: all timeline intervals
        ScatterPlotView(moodEntries: [])
            .navigationTitle("Mood Overiew")

    }
}

struct MoodOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        MoodOverviewView()
    }
}
