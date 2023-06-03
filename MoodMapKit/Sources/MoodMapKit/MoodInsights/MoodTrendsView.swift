//
//  MoodTrendsView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import SwiftUI

/// A view that displays mood trends data.
///
/// Use `MoodTrendsView` to create a view that presents mood trends data.
/// It can be used to visualize and analyze trends in mood data over time.
public struct MoodTrendsView: View {

    /// The body view of the MoodTrendsView.
    public var body: some View {
        VStack {
            Text("Trends Data")
        }
        .padding()
    }
}

struct MoodTrendsView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrendsView()
    }
}
