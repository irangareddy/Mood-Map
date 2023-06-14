//
//  CategoryBackgroundView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 12/06/23.
//

import SwiftUI
import MoodMapKit

struct CategoryBackgroundView: View {

    let gradient = Gradient(colors: [
                                Color(hex: "#CAB8FF"), Color(hex: "#B5DEFF"),
                                Color(hex: "#C1FFD7"), Color(hex: "#FCFFA6")])

    var body: some View {

        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Angry")
                    .font(.appBody)
                Text("Ipsum ea excepteur ea incididunt nulla mollit sint culpmodo ut deserunt. Esse aute enim Lorem ut nostrud minim cillum excepteur.")
                    .font(.appSmallBody)
            }.padding()
        }
        .frame(width: 300, height: 200)
        .background(.ultraThinMaterial)
        .background(getMoodCategoryColorMine(for: .highEnergyUnpleasant))
        .cornerRadius(20)
        //        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
        //        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 10)

    }
}

struct CategoryBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryBackgroundView()
            CategoryBackgroundView()
                .preferredColorScheme(.dark)
        }
    }
}
