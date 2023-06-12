//
//  CategoryBackgroundView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 12/06/23.
//

import SwiftUI
import MoodMapKit

func getMoodCategoryColorMine(for category: MoodCategory) -> AngularGradient {
    let baseColors: [Color]
    let startAngle: Angle
    let endAngle: Angle

    switch category {
    case .highEnergyPleasant:
        baseColors = [
            Color(hex: "#FF6B6B"), // Vibrant Red
            Color(hex: "#FFADAD"), // Lighter shade of red
            Color(hex: "#FFD6D6") // Even lighter shade of red
        ]
        startAngle = .degrees(-90)
        endAngle = .degrees(360)

    case .highEnergyUnpleasant:
        baseColors = [
            Color(hex: "#FFCC4D"), // Vibrant Yellow
            Color(hex: "#FFE698"), // Lighter shade of yellow
            Color(hex: "#FFF4CC") // Even lighter shade of yellow
        ]
        startAngle = .degrees(-90)
        endAngle = .degrees(360)

    case .lowEnergyPleasant:
        baseColors = [
            Color(hex: "#6AB7FF"), // Vibrant Blue
            Color(hex: "#A5D8FF"), // Lighter shade of blue
            Color(hex: "#D0E9FF") // Even lighter shade of blue
        ]
        startAngle = .degrees(-90)
        endAngle = .degrees(360)

    case .lowEnergyUnpleasant:
        baseColors = [
            Color(hex: "#A65FCA"), // Vibrant Purple
            Color(hex: "#D39EF3"), // Lighter shade of purple
            Color(hex: "#ECCAFF") // Even lighter shade of purple
        ]
        startAngle = .degrees(-90)
        endAngle = .degrees(360)
    }

    let colors = [Color.white] + baseColors
    let gradient = AngularGradient(gradient: Gradient(colors: colors), center: .center, startAngle: startAngle, endAngle: endAngle)

    return gradient
}

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
