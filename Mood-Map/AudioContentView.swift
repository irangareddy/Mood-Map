//
//  AudioContentView.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 10/06/23.
//

import Foundation
import SwiftUI
import AVFoundation

struct AudioContentView: View {
    @ObservedObject var recorder = AudioRecorder()
    @ObservedObject var serverPlayer = MoodViewModel()
    @State private var isPlaying = false
    @State private var currentRecording: Recording?
    @State private var volume: Float = 1.0 // Initial volume level

    var body: some View {
        VStack {
            HStack {
                Text(isPlaying ? "Pause" : "Play")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.gray))
                    .onTapGesture {
                        if let serverRecordering = serverPlayer.recording {
                            self.currentRecording = serverPlayer.recording
                            self.isPlaying = true
                            print(serverRecordering.location?.path)
                        }

                    }

                Spacer()

                Button(action: {
                    if self.recorder.recording == false {
                        self.recorder.startRecording()
                    } else {
                        self.recorder.stopRecording()
                    }
                }) {
                    Text(self.recorder.recording ? "Stop Recording" : "Start Recording")
                }
            }.padding()

            List {
                ForEach(recorder.recordings) { recording in
                    Button(action: {
                        self.currentRecording = recording
                        self.isPlaying = true
                        print(recording.location?.path)
                    }) {
                        VStack(alignment: .leading) {
                            Text(recording.name)
                            if let location = recording.location {
                                Text(location.path)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete { indices in
                    for index in indices {
                        if let url = recorder.recordings[index].location {
                            recorder.deleteRecording(at: url)
                        }
                    }
                }

            }
        }
        .onAppear(perform: {
            Task {
                await serverPlayer.getAudio()
            }

        })
        .sheet(isPresented: $isPlaying, onDismiss: {
            stopPlayback()
        }) {
            if let recording = currentRecording {
                AudioPlayerView(recording: recording, isPlaying: $isPlaying, volume: $volume)
            }
        }
    }

    private func stopPlayback() {
        currentRecording = nil
        isPlaying = false
    }
}

struct AudioPlayerView: View {
    let recording: Recording
    @Binding var isPlaying: Bool
    @Binding var volume: Float
    @State private var player: AVPlayer?

    var body: some View {
        VStack {
            Text("Now Playing")
                .font(.title)
                .padding()

            Text(recording.name)
                .font(.headline)

            Button(action: {
                isPlaying = false
            }) {
                Text("Stop Playback")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()

            if let location = recording.location {
                PlayerControlsView(url: location, isPlaying: $isPlaying, volume: $volume)
            }
        }
        .onAppear {
            if let location = recording.location {
                player = AVPlayer(url: location)
                player?.play()
                player?.volume = volume // Set initial volume
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

struct PlayerControlsView: View {
    let url: URL
    @Binding var isPlaying: Bool
    @Binding var volume: Float

    var body: some View {
        HStack {
            if isPlaying {
                Button(action: {
                    isPlaying = false
                }) {
                    Image(systemName: "pause.fill")
                        .font(.title)
                }
            } else {
                Button(action: {
                    isPlaying = true
                }) {
                    Image(systemName: "play.fill")
                        .font(.title)
                }
            }

            Slider(value: $volume, in: 0.0...1.0, step: 0.1) // Volume slider
                .disabled(!isPlaying) // Disable slider when not playing
        }
    }
}

class AudioRecorder: ObservableObject {
    @ObservedObject var vm = MoodViewModel()
    @Published var recording = false
    @Published var recordings: [Recording] = []

    private var audioRecorder: AVAudioRecorder?
    private var audioURL: URL?

    init() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        audioURL = documentDirectory.appendingPathComponent("recording.wav")

        loadRecordings()
    }

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] as [String: Any]

            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.record()
            recording = true
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        recording = false

        if let audioURL = audioURL {
            saveRecording(at: audioURL)
        }

        loadRecordings()
    }

    func getFormattedFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let currentDateTime = dateFormatter.string(from: Date())

        return "\(currentDateTime).wav"
    }

    //    func saveRecording(at url: URL) {
    //        let fileManager = FileManager.default
    //        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //
    //        let fileName = getFormattedFileName()
    //        let destinationURL = documentsDirectory.appendingPathComponent(fileName)
    //
    //        do {
    //            try fileManager.moveItem(at: url, to: destinationURL)
    //            print("Recording saved successfully.")
    //        } catch {
    //            print("Error saving recording: \(error.localizedDescription)")
    //        }
    //
    //        loadRecordings()
    //    }
    //
    //    func deleteRecording(at url: URL) {
    //        let fileManager = FileManager.default
    //
    //        do {
    //            try fileManager.removeItem(at: url)
    //            print("Recording deleted successfully.")
    //        } catch {
    //            print("Error deleting recording: \(error.localizedDescription)")
    //        }
    //
    //        loadRecordings()
    //    }

    func saveRecording(at url: URL) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let fileName = getFormattedFileName()
        let destinationURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            try fileManager.moveItem(at: url, to: destinationURL)
            print("Recording saved successfully.")

            // Save audio recording to the server
            Task {
                do {
                    await             vm.saveAudioRecording(fileURL: destinationURL)
                }
            }

        } catch {
            print("Error saving recording: \(error.localizedDescription)")
        }

        loadRecordings()
    }

    func deleteRecording(at url: URL) {
        let fileManager = FileManager.default

        do {
            try fileManager.removeItem(at: url)
            print("Recording deleted successfully.")
        } catch {
            print("Error deleting recording: \(error.localizedDescription)")
        }

        loadRecordings()
    }

    func loadRecordings() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        do {
            let urls = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            recordings = urls.filter { $0.pathExtension == "wav" }.map { Recording(name: $0.lastPathComponent, location: $0) }
        } catch {
            print("Error loading recordings: \(error.localizedDescription)")
        }
    }
}

struct Recording: Identifiable {
    let id = UUID()
    let name: String
    let location: URL?
}
