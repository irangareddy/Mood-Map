//
//  CheckInView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 03/06/23.
//

import SwiftUI
import MoodMapKit
import Lottie

func timeOfDayGreeting() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        switch hour {
        case 0:
            return "Midnight"
        case 1..<6:
            return "Dawn"
        case 6..<12:
            return "Morning"
        case 12:
            return "Midday"
        case 13..<17:
            return "Afternoon"
        case 17..<18:
            return "Evening"
        case 18..<24:
            return "Night"
        default:
            return "Unknown"
        }
    }

struct CheckInView: View {

    @State private var doesPreviousEntriesExists = false
    @Environment(\.colorScheme) var scheme

    var body: some View {

        VStack {
            GeometryReader { proxy in

                VStack(alignment: .center) {
                    Text("How are you feeling this \(timeOfDayGreeting())?")
                        .font(.appTitle2)
                        .multilineTextAlignment(.center)
                    ZStack {
                        ZStack {
                            RingAnimationView()
                                .rotationEffect(.init(degrees: 90))
                            RingAnimationView()
                                .rotationEffect(.init(degrees: 270))
                        }
                        .padding(8)

                        Button {
                            NavigationController.pushController(UIHostingController(rootView: MoodView()))
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(scheme == .dark ? Color.white : Color.black)
                                    )
                                    .foregroundColor(scheme == .dark ? Color.black : Color.white)

                                Text("Check In")
                                    .font(.appHeadline)

                            }.background(RoundedRectangle(cornerRadius: 16).foregroundColor(Color.clear))

                        }

                    }.frame(maxWidth: .infinity, maxHeight: proxy.size.height / 3)
                    Spacer()
                    VStack(alignment: .leading) {
                        if doesPreviousEntriesExists {

                            // TODO: Show Last 3 Activities

                        } else {
                            QuotesView()
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height / 2)
                    Spacer()
                    Spacer()

                }.padding(8)
 

            }
            .padding()
        }.navigationBarHidden(true)

    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckInView()
            CheckInView()
                .preferredColorScheme(.dark)
        }
    }
}

struct RingAnimationView: View {
    @State private var progress: CGFloat = 0.0

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.primary.opacity(progress), .secondary.opacity(1 - progress)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .rotationEffect(.degrees(-90))
                .opacity(fadeValue(for: progress))

            Circle()

                .trim(from: progress, to: progress + 0.01) // Use a small increment
                .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.primary.opacity(progress), .secondary.opacity(1 - progress)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .rotationEffect(.degrees(-90))
                .opacity(0.0) // Hide the chasing cap
        }
        .onAppear {
           animateProgress()
        }
    }

    private func animateProgress() {
        withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: true)) {
            progress = 1.0
        }
    }

    private func fadeValue(for progress: CGFloat) -> Double {
        let fadeThreshold: CGFloat = 0.8
        if progress <= fadeThreshold {
            return Double(progress / fadeThreshold)
        } else {
            return Double((1.2 * progress) / (1.0 + fadeThreshold))
        }
    }
}

extension NavigationController {
    static func onLogout() {
        UIApplication.shared.keyWindow?.rootViewController = UIHostingController(rootView: ContentView())
    }
}
