//
//  MoodCheckInView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import MoodMapKit
import PhotosUI

struct MoodView: View {
    @ObservedObject var emoozee = Emoozee()
    @State private var moodSelected: Mood?

    var body: some View {
        VStack(alignment: .leading) {
            if moodSelected != nil {

                Text("Feeling \(moodSelected?.name ?? "")")
                    .font(.appTitle2)
                    .transition(.slide)
            } else {
                Text("How are you feeling?")
                    .font(.appTitle2)
                    .transition(.slide)
            }

            MoodGridView(moodSelected: $moodSelected, moods: emoozee.moodData.moods)

        }
        .padding()
    }
}

struct MoodCheckInView: View {
    @Binding var selectedMood: Mood
    @State private var picture: Image?
    @State private var audio: Data?
    @State private var notes: String = ""
    @State private var place: Place?
    @State private var exerciseHours: String = ""
    @State private var sleepHours: String = ""
    @State private var weather: Weather?
    @ObservedObject var emoozee = Emoozee()

    var body: some View {
        NavigationStack {

            Form {
                Section(header: Text("Mood"), footer: Text("Choose your current mood").font(.appCaption)) {
                    Picker(selection: $selectedMood, label: Text("Feeling")) {
                        ForEach(emoozee.moodData.moods) { mood in
                            Text(mood.title)
                                .tag(mood)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Add a note"), footer: Text("Write down any additional notes about your mood").font(.appCaption)) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }

                Section(header: Text("Media"), footer: Text("Add a touch of magic to your mood with media").font(.appCaption)) {
                    #if os(iOS)
                    PhotoPickerView()
                    #endif
                    HStack {
                        Text("Add a voice note")
                            .font(.appBody)
                        Spacer()
                        Image(systemName: "mic")
                    }

                }

                Section(header: Text("Place"), footer: Text("Select your current location or environment").font(.appCaption)) {
                    Picker(selection: $place, label: Text("Feeling")) {
                        ForEach(Place.allCases) { place in
                            Text(place.rawValue.capitalized)
                                .tag(place)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Well-being"), footer: Text("Track your exercise and sleep hours").font(.appCaption)) {
                    HStack {
                        Text("Exercise")
                        Spacer()
                        TextField("Hours", text: $exerciseHours)
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Sleep")
                        Spacer()
                        TextField("Hours", text: $sleepHours)
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section(header: Text("Weather"), footer: Text("Select the weather condition").font(.appCaption)) {
                    Picker(selection: $weather, label: Text("Feeling")) {
                        ForEach(Weather.allCases) { weather in
                            Text(weather.rawValue.capitalized)
                                .tag(weather)
                        }
                    }
                    .pickerStyle(.menu)
                }

            }.safeAreaInset(edge: .bottom) {
                FloatingButton(action: {
                    // Perform some action here...
                }, icon: "plus")
            }

            .navigationTitle("Mood Check-In")
        }
    }
}

// struct MoodCheckInView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoodCheckInView(selectedMood: .constant())
//    }
// }
#if os(iOS)
enum PhotoActions: String, CaseIterable, Identifiable {
    case remove

    var id: String { self.rawValue }

    func handleAction(contentView: PhotoPickerView) {
        // Perform the action associated with each option
        switch self {
        case .remove:
            contentView.removePicture()
        }
    }
}

struct PhotoPickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showActionSheet = false
    @State private var selectedOption: PhotoActions?

    var body: some View {
        VStack {
            if let selectedImageData = selectedImageData,

               let uiImage = UIImage(data: selectedImageData) {
                // Display the selected image
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .onTapGesture {
                        showActionSheet.toggle()
                    }
                    .confirmationDialog("Photo Actions", isPresented: $showActionSheet, titleVisibility: .visible) {
                        ForEach(PhotoActions.allCases, id: \.self) { option in
                            // Action buttons for each option
                            Button(option.rawValue.capitalized) {
                                selectedOption = option
                                handleOptionSelected(option)
                            }
                        }
                    }
            } else {
                HStack {
                    // Placeholder text and photo picker button
                    Text("Add a photo")
                        .font(.appBody)
                    Spacer()
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                        Image(systemName: "camera.macro")
                    }
                    .onChange(of: selectedItem) { newItem in
                        if selectedItem == nil {
                            // Do nothing
                        } else {
                            Task {
                                // Retrieve selected asset in the form of Data
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    }
                }
                .padding(2)
            }
        }
    }

    func removePicture() {
        selectedItem = nil
        selectedImageData = nil
    }

    func handleOptionSelected(_ option: PhotoActions) {
        switch option {
        case .remove:
            removePicture()
        }
    }
}

#endif

struct FloatingButton: View {
    let action: () -> Void
    let icon: String
    var body: some View {
        ZStack {
            HStack {
                Button(action: action) {
                    Text("Save")
                        .font(.appCallout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 300, height: 60)
                .background(Color.red)
                .cornerRadius(30)
                .shadow(radius: 10)
                .padding()
            }
        }
    }
}
