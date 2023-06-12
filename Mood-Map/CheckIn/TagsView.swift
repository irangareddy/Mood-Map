//
//  TagsView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 11/06/23.
//

import Foundation
import MoodMapKit
import SwiftUI
import Lottie

func getAllRawValues<T: RawRepresentable & CaseIterable>(ofEnum enumType: T.Type) -> [String] where T.RawValue: Equatable {
    return enumType.allCases.map { String(describing: $0.rawValue).capitalized }
}

struct TagsView: View {
    var title: String
    var cases: [String]
    var lottieIcon: MoodMapAnimatedIcons
    var lottieView = LottieAnimationView(name: MoodMapAnimatedIcons.settings.fileName, bundle: .main)
    var geometry: GeometryProxy
    var size: CGFloat
    @Binding var selectedValue: String

    init(title: String, cases: [String], lottieIcon: MoodMapAnimatedIcons, geometry: GeometryProxy, size: CGFloat = 8, selectedValue: Binding<String>) {
        self.title = title
        self.cases = cases
        self.lottieIcon = lottieIcon
        self.lottieView = LottieAnimationView(name: lottieIcon.fileName, bundle: .main)
        self.geometry = geometry
        self.size = size
        self._selectedValue = selectedValue
    }

    var body: some View {

        VStack(alignment: .leading) {
            CheckInLabel(text: title, lottieView: lottieView)
            TestWrappedLayout(selectedText: $selectedValue, platforms: cases, geometry: geometry)

                .frame(height: geometry.size.height/size)
            Divider()
        }

    }
}

struct TagsView_Previews: PreviewProvider {
    @State static private var selectedWeather: String = "Sunny"
    @State static private var selectedPlace: String = "Home"

    static var previews: some View {
        GeometryReader { geometry in
            VStack {
                TagsView(title: "Weather", cases: getAllRawValues(ofEnum: Weather.self), lottieIcon: MoodMapAnimatedIcons.memoryLane, geometry: geometry, size: 6, selectedValue: $selectedWeather)
                TagsView(title: "Place", cases: getAllRawValues(ofEnum: Place.self), lottieIcon: MoodMapAnimatedIcons.memoryLane, geometry: geometry, size: 6, selectedValue: $selectedPlace)
            }
        }
    }
}

struct TestWrappedLayout: View {
    @Binding var selectedText: String
    var platforms: [String]
    let geometry: GeometryProxy

    var body: some View {
        self.generateContent(in: geometry)
            .frame(maxHeight: geometry.size.height/3)
    }

    func item(for text: String) -> some View {
        let isSelected = text == selectedText

        return Text(text)
            .padding(10)
            .font(.appSmallBody)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.accentColor : Color.gray, lineWidth: 1)
            )
            .onTapGesture {
                selectedText = isSelected ? "" : text
            }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.platforms, id: \.self) { platform in
                self.item(for: platform)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > g.size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if platform == self.platforms.first! {
                            width = 0 // last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {_ in
                        let result = height
                        if platform == self.platforms.first! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
}
