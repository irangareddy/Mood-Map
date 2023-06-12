//
//  VoiceNoteIntentView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 11/06/23.
//

import Foundation
import SwiftUI
import Lottie
import MoodMapKit

struct VoiceNoteIntentView: View {
    @State private var isPickerShown = true
    var body: some View {
        VStack {
            Text("VoiceNoteIntentView")

        }.sheet(isPresented: $isPickerShown) {
            MusicControllerView()
        }

    }
}

struct MusicControllerView: View {
    @State private var isPlaying: Bool = false
    @State private var volume: Double = 0.5 // Example volume value
    @State private var currentTime: TimeInterval = 0
    let totalTime: TimeInterval = 240 // Example total duration
    let lottieView = LottieAnimationView(name: MoodMapAnimatedIcons.speaker.fileName, bundle: .main)
    @State private var timer: Timer?

    @State private var sliderValue: TimeInterval = 0

    func playAnimation() {
        lottieView.play { _ in
            if isPlaying {
                playAnimation() // Recursively call the function to repeat the animation
            }
        }
    }

    var body: some View {
        VStack(spacing: 16) {

            VStack {
                Text("Happy-April-23-2023")
                    .font(.appHeadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 16) {
                HStack {
                    Text(timeString(from: currentTime))
                        .font(.caption)
                        .foregroundColor(.gray)

                    Slider(value: Binding(
                        get: { sliderValue },
                        set: { newValue in
                            sliderValue = newValue
                            if !isPlaying {
                                currentTime = newValue
                            }
                        }
                    ), in: 0...totalTime)
                    .accentColor(.green)

                    Text(timeString(from: totalTime))
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                ResizableLottieView(lottieView: lottieView, color: Color.pink, loopMode: .loop)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .contentShape(RoundedRectangle(cornerRadius: 34))
                    .blendMode(.normal)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isPlaying.toggle()
                            if isPlaying {
                                startTimer()
                                playAnimation()
                            } else {
                                stopTimer()

                            }
                        }
                    }
            }
        }                .frame(maxWidth: .infinity)
        .padding()
        .presentationDetents([.height(200)])
        .onDisappear {
            stopTimer()
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            sliderValue += 1
            if sliderValue >= totalTime {
                sliderValue = 0
                stopTimer()
            }
            if !isPlaying {
                currentTime = sliderValue
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct VoiceNoteIntentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VoiceNoteIntentView()
            VoiceNoteIntentView()
                .preferredColorScheme(.dark)
        }
    }
}
