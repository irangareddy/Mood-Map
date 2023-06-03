//
//  MoodDistributionView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import SwiftUI

/// A view that displays the distribution of moods.
///
/// Use `MoodDistributionView` to create a view that presents the distribution of moods.
/// It can be used to visualize and analyze the distribution of different mood categories or types.
public struct MoodDistributionView: View {

    /// The body view of the MoodDistributionView.
    public var body: some View {
        VStack {
            Text("MoodDistributionView")
        }
        .padding()
    }
}

struct MoodDistributionView_Previews: PreviewProvider {
    static var previews: some View {
        MoodDistributionView()
    }
}
