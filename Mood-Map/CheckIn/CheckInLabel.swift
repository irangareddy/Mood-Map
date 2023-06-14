//
//  CheckInLabel.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 11/06/23.
//

import Foundation
import SwiftUI
import Lottie
import MoodMapKit

struct CheckInLabel: View {
    let text: String
    let lottieView: LottieAnimationView
    @State private var isAnimationPlaying = false

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(text)
                    .font(.appBody)
                Spacer()

                if text.contains("weather") {
                    Image(systemName: "cloud")
                        .font(.subheadline)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                } else if text.contains("are you") {
                    Image(systemName: "location")
                        .font(.subheadline)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "pencil")
                        .font(.subheadline)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

protocol EnumProtocol: RawRepresentable, CaseIterable, Hashable, Identifiable where RawValue: Hashable {}

extension EnumProtocol {
    var id: RawValue { rawValue }
}

struct CheckInLabelEnum<Enum: EnumProtocol, Content: View>: View where Enum.AllCases: RandomAccessCollection {
    let enumValue: Enum
    let text: String
    let lottieView: LottieAnimationView
    let content: () -> Content
    @State private var isAnimationPlaying = false

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(text)
                    .font(.appBody)
                Spacer()
                ResizableLottieView(lottieView: lottieView, color: Color.accentColor)
                    .frame(width: 30, height: 30)
                    .onAppear {
                        lottieView.play { _ in
                            // Animation completion handler
                        }
                    }
            }
            HStack(alignment: .center) {
                ForEach(Array(Enum.allCases), id: \.self) { enumCase in
                    Text(String(describing: enumCase.rawValue))
                        .padding(4)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            content()
            Divider()
        }.padding(.horizontal)
    }
}

struct CheckInLabel_Previews: PreviewProvider {
    static var previews: some View {
        let lottieView = LottieAnimationView(name: MoodMapAnimatedIcons.settings.fileName, bundle: .main)

        Group {
            VStack {
                CheckInLabel(text: "Sunday Jun 11, 5:08 PM", lottieView: lottieView)
                CheckInLabelEnum(enumValue: MyEnum.optionA, text: "My Enum", lottieView: LottieAnimationView(name: "animation")) {
                    Text("Extra Content")
                }
            }
        }
    }
}

enum MyEnum: EnumProtocol {
    typealias RawValue = String

    case optionA
    case optionB
    case optionC
    case optionD
    case optionE
    case optionF
    case optionG
    case optionH
    case optionI
    case optionJ
}

extension MyEnum {
    init?(rawValue: String) {
        switch rawValue {
        case "optionA":
            self = .optionA
        case "optionB":
            self = .optionB
        case "optionC":
            self = .optionC
        case "optionD":
            self = .optionD
        case "optionE":
            self = .optionE
        case "optionF":
            self = .optionF
        case "optionG":
            self = .optionG
        case "optionH":
            self = .optionH
        case "optionI":
            self = .optionI
        case "optionJ":
            self = .optionJ
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .optionA:
            return "optionA"
        case .optionB:
            return "optionB"
        case .optionC:
            return "optionC"
        case .optionD:
            return "optionD"
        case .optionE:
            return "optionE"
        case .optionF:
            return "optionF"
        case .optionG:
            return "optionG"
        case .optionH:
            return "optionH"
        case .optionI:
            return "optionI"
        case .optionJ:
            return "optionJ"
        }
    }
}
