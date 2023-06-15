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
    @ObservedObject var recorder = AudioRecorder.shared
    @ObservedObject var viewModel = MoodViewModel.shared
    @Binding var id: String?
    @State private var isPlaying = false
    @State private var currentRecording: Recording?
    @State private var isRecording = false
    @State private var volume: Float = 1.0 // Initial volume level
    var recorderView: Bool // Boolean value to determine whether to show the recording button or play button
    var voiceNoteIdentifier: String? // String value for the voice note identifier

    var body: some View {
        VStack {
            HStack {
                if recorderView {

                    WaveAnimationButton(isRecording: $isRecording, action: {
                        // Perform your action here
                        print("Button tapped")
                        if self.recorder.recording == false {
                            self.recorder.startRecording()
                        } else {
                            Task {
                                do {

                                    let url = try await self.recorder.stopRecording()
                                    print("Saving ID \(url)")

                                    Task {
                                        do {
                                            let response = await viewModel.saveAudioRecording(fileURL: url!)
                                            self.id = response
                                        }
                                    }

                                    // Perform any additional tasks or operations after the response is sent

                                } catch {
                                    print("Error stopping recording: \(error)")
                                }
                            }

                        }
                    })
                } else {
                    Button(action: {
                        if let serverRecording = viewModel.recording {
                            self.currentRecording = viewModel.recording
                            self.isPlaying = true
                            print(serverRecording.location?.path)
                        }
                    }) {
                        Text("Play")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.gray))
                    }        .onAppear {
                        if let id = voiceNoteIdentifier {
                            Task {
                                await viewModel.getVoiceNote(of: id)
                                print("Getting Vocice")
                            }
                        }

                    }
                }

                Spacer()
            }
            .padding()

//                        List {
//                            ForEach(recorder.recordings) { recording in
//                                Button(action: {
//                                    self.currentRecording = recording
//                                    self.isPlaying = true
//                                    print(recording.location?.path)
//                                }) {
//                                    VStack(alignment: .leading) {
//                                        Text(recording.name)
//                                        if let location = recording.location {
//                                            Text(location.path)
//                                                .font(.caption)
//                                                .foregroundColor(.gray)
//                                        }
//                                    }
//                                }
//                            }
//                            .onDelete { indices in
//                                for index in indices {
//                                    if let url = recorder.recordings[index].location {
//                                        recorder.deleteRecording(at: url)
//                                    }
//                                }
//                            }
//                        }
        }

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
    public static let shared = AudioRecorder()
    @ObservedObject var vm = MoodViewModel.shared
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

    func stopRecording() async -> URL? {
        audioRecorder?.stop()
        recording = false
        print("Stopped Recording")

        if let audioURL = audioURL {
            print("Saving Recording")

            let response = await saveRecording(at: audioURL)
            return response
        }

        loadRecordings()
        return nil
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

    func saveRecording(at url: URL) async  -> URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let fileName = getFormattedFileName()
        let destinationURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            try fileManager.moveItem(at: url, to: destinationURL)
            print("Local Recording saved successfully.")

            // Save audio recording to the server
            return destinationURL

        } catch {
            print("Error saving recording: \(error.localizedDescription)")
        }

        loadRecordings()
        return nil
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

struct WaveShape: Shape {
    var offset: CGFloat
    var waveLength: CGFloat // Added wave length property
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        var path = Path()
        path.move(to: CGPoint(x: 0, y: height / 2))

        for x in stride(from: 0, to: width, by: waveLength) { // Use waveLength for stride
            let y = height / 2 + sin((CGFloat(x) / width) * 2 * .pi + offset) * height / 4
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}

struct WaveAnimationButton: View {
    @Binding var isRecording: Bool
    @State private var waveOffset: CGFloat = 0
    var action: () -> Void // Closure to be executed when the button is tapped

    var body: some View {
        HStack {
            Spacer()

            WaveShape(offset: waveOffset, waveLength: 30)
                .foregroundColor(.accentColor)
                .opacity(isRecording ? 0.3 : 0)

            Button(action: {
                if isRecording {
                    withAnimation(.linear(duration: 0.3)) {
                        waveOffset = 0
                    }
                } else {
                    withAnimation(Animation.linear(duration: 2).repeatForever()) {
                        waveOffset += 2 * .pi
                    }
                }

                isRecording.toggle()
                action() // Call the provided closure
            }) {
                Image(systemName: isRecording ? "record.circle.fill" : "stop.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.accentColor)
            }
            .padding(.trailing, 16)
        }
        .onAppear {
            if isRecording {
                withAnimation(Animation.linear(duration: 2).repeatForever()) {
                    waveOffset += 2 * .pi
                }
            }
        }
    }
}
