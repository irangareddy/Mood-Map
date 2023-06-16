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
import AVFoundation

struct VoiceNoteIntentView: View {
    @State private var isPickerShown = true
    var body: some View {
        VStack {
            Text("VoiceNoteIntentView")

        }.sheet(isPresented: $isPickerShown) {
            MusicControllerView(recording: Recording(name: "", location: nil))
        }

    }
}

class MusicPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?

    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var totalTime: TimeInterval = 0

    func playMusic(withFilePath filePath: String) {
        guard let url = URL(string: filePath) else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            totalTime = audioPlayer?.duration ?? 0
            audioPlayer?.play()
            isPlaying = true
            startTimer()
        } catch {
            debugPrint("Failed to play music: \(error)")
        }
    }

    func stopMusic() {
        audioPlayer?.stop()
        isPlaying = false
        resetTimer()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        resetTimer()
    }

    private var timer: Timer?

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.audioPlayer?.currentTime ?? 0

            if self.currentTime >= self.totalTime {
                self.stopMusic()
            }
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        currentTime = 0
    }
}

struct MusicControllerView: View {
    @StateObject private var musicPlayer = MusicPlayer()
    private let recording: Recording
    let lottieView = LottieAnimationView(name: MoodMapAnimatedIcons.speaker.fileName, bundle: .main)

    init(recording: Recording) {
        self.recording = recording
    }

    func playAnimation() {
        lottieView.play { _ in
            if musicPlayer.isPlaying {
                playAnimation() // Recursively call the function to repeat the animation
            }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text(recording.name)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 16) {
                HStack {
                    Text(timeString(from: musicPlayer.currentTime))
                        .font(.caption)
                        .foregroundColor(.gray)

                    Slider(value: $musicPlayer.currentTime, in: 0...musicPlayer.totalTime)
                        .accentColor(.green)

                    Text(timeString(from: musicPlayer.totalTime))
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
                                         musicPlayer.isPlaying.toggle()
                                         if musicPlayer.isPlaying {
                                             musicPlayer.playMusic(withFilePath: recording.location?.path ?? "")
                                         } else {
                                             musicPlayer.stopMusic()
                                         }
                                     }
                                 }

            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .presentationDetents([.height(100)])
        .onAppear {
            musicPlayer.playMusic(withFilePath: recording.location?.path ?? "")
        }
    }

    func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct MusicControllerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicControllerView(recording: Recording(name: "Hello", location: URL(string: "path/to/your/music/file.mp3")))
    }
}
