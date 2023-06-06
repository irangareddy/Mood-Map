//
//  CheckInView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 03/06/23.
//

import SwiftUI
import MoodMapKit
import Lottie

struct CheckInView: View {

    @State private var doesPreviousEntriesExists = true
    @Environment(\.colorScheme) var scheme

    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack(alignment: .center) {
                    Text("How are you feeling this evening?")
                        .font(.appTitle2)
                        .multilineTextAlignment(.center)
                    ZStack {
                        ZStack {
                            RingAnimationView()
                                .rotationEffect(.init(degrees: 90))
                            RingAnimationView()
                                .rotationEffect(.init(degrees: 270))
                        }                    .padding(8)

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
                        }

                    }.background(RoundedRectangle(cornerRadius: 16).foregroundColor(Color.clear))
                    .frame(maxWidth: .infinity, maxHeight: proxy.size.height / 3)

                }.padding(8)

                VStack(alignment: .leading) {
                    if doesPreviousEntriesExists {

                        // TODO: Show Last 3 Activities

                    } else {
                        Divider()
                            .frame(height: 2)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 8)
                        Text(NO_EMOTIONS_MESSAGES.randomElement()!)
                            .font(.appSubheadline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: proxy.size.height/3)
                            .padding(16)
                    }
                }

            }.navigationTitle("Check In")
            .padding()
        }
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
