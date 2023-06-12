//
//  MoodCheckInView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import MoodMapKit
import PhotosUI
import Lottie

// MARK: - MoodView

struct MoodView: View {
    @ObservedObject var emoozee = Emoozee()
    @State private var moodSelected: Mood?

    var body: some View {
        MoodGridView(moodSelected: $moodSelected,
                     moods: emoozee.moodData.moods,
                     closeView: {
                        NavigationController.popView()
                     },
                     circleTappedAction: {
                        NavigationController.pushController(UIHostingController(rootView: MoodCheckInView(selectedMood: $moodSelected)))

                     })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public func lottieView(for icon: MoodMapAnimatedIcons) -> LottieAnimationView {
    return LottieAnimationView(name: icon.fileName, bundle: .main)
}

// MARK: - MoodCheckInView

struct MoodCheckInView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    let moodVM = MoodViewModel.shared
    @Binding var selectedMood: Mood?
    @State private var date: Date = .now
    @State private var picture: UIImage?
    @State private var audio: Data?
    @State private var notes: String = ""
    @State private var place: String = ""
    @State private var exerciseHours: String = ""
    @State private var sleepHours: String = ""
    @State private var weather: String = ""
    @State private var imageId: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    // Top
                    VStack(alignment: .leading) {
                        Text("I'm feeling")
                        Text(selectedMood!.name)
                            .foregroundColor(backgroundForCategory(MoodCategory(rawValue: (selectedMood?.category)!.rawValue) ?? MoodCategory.highEnergyPleasant))
                    }
                    .font(.appTitle2)
                    .multilineTextAlignment(.leading)
                    
                    DateLabel(selectedDate: $date, lottieView: lottieView(for: .edit))
                    
                    // Photo Picker
                    PhotoPickerView(selectedUIImage: $picture)
                    
                    // Voice Note
                    VoiceNoteView(lottieView: lottieView(for: .microphoneRecording))
                    
                    // Note
                    NoteView(notes: $notes, geometry: geometry)
                    
                    // Tags
                    TagsView(title: "Where are you?", cases: getAllRawValues(ofEnum: Place.self), lottieIcon: MoodMapAnimatedIcons.location, geometry: geometry, size: 5, selectedValue: $place)
                    
                    TagsView(title: "Weather", cases: getAllRawValues(ofEnum: Weather.self), lottieIcon: MoodMapAnimatedIcons.weather, geometry: geometry, size: 5, selectedValue: $weather)
                        .padding(.top, 8)
                    
                    // Exercise
                    ExerciseView(lottieView: lottieView(for: .exercise), exerciseHours: $exerciseHours)
                    
                    // Sleep
                    SleepView(lottieView: lottieView(for: .sleep), sleepHours: $sleepHours)
                    
                }
                .padding()
            }
            .redacted(reason: selectedMood == nil ? .placeholder : [])
            .safeAreaInset(edge: .bottom) {
                FloatingButton(action: {
                    // Perform some action here...
                    createEntry()
                    NavigationController.popToRootView()
                }, icon: "plus")
            }
            .onReceive(moodVM.$appError) { error in
                if let localizedError = error {
                    print("\(localizedError) from the view")
                    errorHandling.handle(error: localizedError)

                }
            }
            .onChange(of: picture) { newImage in
                Task {
                    do {
                        if let pictureId = await moodVM.saveImage(loaded: newImage) {
                            self.imageId = pictureId
                        }
                    }
                }
            }
        }
    }
    
    private func createEntry() {
        guard let selectedMood = selectedMood else {
            print("No selected mood")
            return
        }
        
        let weatherEnum: Weather? = Weather.allCases.first { $0.rawValue == weather.lowercased() }
        let placeEnum: Place? = Place.allCases.first { $0.rawValue == place.lowercased() }
        
        print("Selected Mood: \(selectedMood.name)")
        print("Date: \(date)")
        print("Notes: \(notes)")
        print("Audio: \(String(describing: audio))")
        print("Picture: \(String(describing: imageId))")
        print("Weather: \(weatherEnum?.rawValue ?? "Unknown")")
        print("Place: \(placeEnum?.rawValue ?? "Unknown")")
        print("Sleep Hours: \(sleepHours)")
        print("Exercise Hours: \(exerciseHours)")
        
        // Assuming moodVM is an instance of the MoodViewModel class
        
        // Convert exerciseHours string to an Int
        let exerciseHoursInt = Double(exerciseHours)
        let sleepHoursInt = Double(sleepHours)
        

        // Create a new MoodEntry instance
        // Assuming moodVM is an instance of the MoodViewModel class

        // Create a new MoodEntry instance
        let moodEntry: MoodEntry = MoodEntry(moods: [selectedMood], timestamp: Date(), imageId: imageId, voiceNoteId: nil, notes: notes, place: placeEnum, exerciseHours: exerciseHoursInt, sleepHours: sleepHoursInt, weather: weatherEnum)


        
        // Use the moodVM to append the moodEntry
        moodVM.append(mood: moodEntry) {
            // Completion handler called after appending the moodEntry
            // Handle any necessary actions or UI updates
        }
    }
    
}

// MARK: - VoiceNoteView

struct VoiceNoteView: View {
    let lottieView: LottieAnimationView

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("Add a voice note")
                    .font(.appBody)
                Spacer()
                ResizableLottieView(lottieView: lottieView, color: Color.accentColor)
                    .frame(width: 30, height: 30)
                    .onAppear {
                        lottieView.play { _ in
                        }
                    }
                    .blendMode(.normal)
            }.padding(.vertical, 2)
            Divider()
        }
    }
}

// MARK: - NOTE VIEW

struct NoteView: View {
    @Binding var notes: String
    var geometry: GeometryProxy

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Add a note")
                    .font(.appBody)
                Spacer()
                ResizableLottieView(lottieView: LottieAnimationView(name: MoodMapAnimatedIcons.document.fileName, bundle: .main), color: Color.accentColor)
                    .frame(width: 30, height: 30)
                    .blendMode(.normal)
            }
            TextEditor(text: $notes)
                .foregroundColor(Color.gray)
                .frame(height: geometry.size.height/10)
            Divider()
        }
        .padding(.vertical, 2)
    }
}

// MARK: - EXERCISE VIEW

struct ExerciseView: View {
    let lottieView: LottieAnimationView
    @Binding var exerciseHours: String

    var body: some View {
        VStack {
            HStack {
                ResizableLottieView(lottieView: lottieView, color: Color.accentColor)
                    .frame(width: 30, height: 30)
                    .onAppear {
                        lottieView.play { _ in
                        }
                    }
                    .blendMode(.normal)
                Text("Exercise")
                Spacer()
                TextField("Hours", text: $exerciseHours)
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.top, 8)
            Divider()
        }
    }
}

// MARK: - SLEEP VIEW

struct SleepView: View {
    let lottieView: LottieAnimationView
    @Binding var sleepHours: String

    var body: some View {
        VStack {
            HStack {
                ResizableLottieView(lottieView: lottieView, color: Color.accentColor)
                    .frame(width: 30, height: 30)
                    .onAppear {
                        lottieView.play { _ in
                        }
                    }
                    .blendMode(.normal)
                Text("Sleep")
                Spacer()
                TextField("Hours", text: $sleepHours)
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - MoodCheckInView Previews

struct MoodCheckInView_Previews: PreviewProvider {
    static var previews: some View {
        let emoozee = Emoozee()
        let placeholderMood = emoozee.placeholderMoods().first
        return MoodCheckInView(selectedMood: .constant(placeholderMood))
    }
}

// struct MoodCheckInView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoodView()
//    }
// }

// MARK: - PhotoActions

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

// MARK: - PhotoPickerView

//struct PhotoPickerView: View {
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var selectedImageData: Data?
//    @State private var showActionSheet = false
//    @State private var selectedOption: PhotoActions?
//    let lottieView = LottieAnimationView(name: MoodMapAnimatedIcons.camera.fileName, bundle: .main)
//
//    var body: some View {
//        VStack {
//            if let selectedImageData = selectedImageData,
//
//               let uiImage = UIImage(data: selectedImageData) {
//                // Display the selected image
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFill()
//                    .onTapGesture {
//                        showActionSheet.toggle()
//                    }
//                    .confirmationDialog("Photo Actions", isPresented: $showActionSheet, titleVisibility: .visible) {
//                        ForEach(PhotoActions.allCases, id: \.self) { option in
//                            // Action buttons for each option
//                            Button(option.rawValue.capitalized) {
//                                selectedOption = option
//                                handleOptionSelected(option)
//                            }
//                        }
//                    }
//            } else {
//                VStack {
//                    HStack {
//                        // Placeholder text and photo picker button
//                        Text("Add a photo")
//                            .font(.appBody)
//                        Spacer()
//                        PhotosPicker(
//                            selection: $selectedItem,
//                            matching: .images,
//                            photoLibrary: .shared()) {
//                            ResizableLottieView(lottieView: lottieView, color: Color.accentColor, loopMode: .loop)
//                                .frame(width: 30, height: 30)
//                                .onAppear {
//                                    lottieView.play { _ in
//                                        // Animation completion handler
//                                    }
//                                }
//                        }
//                        .onChange(of: selectedItem) { newItem in
//                            if selectedItem == nil {
//                                // Do nothing
//                            } else {
//                                Task {
//                                    // Retrieve selected asset in the form of Data
//                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
//                                        selectedImageData = data
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(2)
//                    Divider()
//                }
//            }
//        }
//    }
//
//    func removePicture() {
//        selectedItem = nil
//        selectedImageData = nil
//    }
//
//    func handleOptionSelected(_ option: PhotoActions) {
//        switch option {
//        case .remove:
//            removePicture()
//        }
//    }
//}


struct PhotoPickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @Binding var selectedUIImage: UIImage?
    @State private var showActionSheet = false
    @State private var selectedOption: PhotoActions?
    let lottieView = LottieAnimationView(name: MoodMapAnimatedIcons.camera.fileName, bundle: .main)

    var body: some View {
        VStack {
            if let uiImage = selectedUIImage {
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
                VStack {
                    HStack {
                        // Placeholder text and photo picker button
                        Text("Add a photo")
                            .font(.appBody)
                        Spacer()
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                            ResizableLottieView(lottieView: lottieView, color: Color.accentColor, loopMode: .loop)
                                .frame(width: 30, height: 30)
                                .onAppear {
                                    lottieView.play { _ in
                                        // Animation completion handler
                                    }
                                }
                        }
                        .onChange(of: selectedItem) { newItem in
                            if selectedItem == nil {
                                // Do nothing
                            } else {
                                Task {
                                    
                                    // Retrieve selected asset in the form of Data
                                                          if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                              let selectedImageData = data
                                                              selectedUIImage = UIImage(data: selectedImageData)
                                                          }
                                    
                                }
                            }
                        }
                    }
                    .padding(2)
                    Divider()
                }
            }
        }
    }

    func removePicture() {
        selectedItem = nil
        selectedUIImage = nil
    }

    func handleOptionSelected(_ option: PhotoActions) {
        switch option {
        case .remove:
            removePicture()
        }
    }
}

#endif

// MARK: - FloatingButton

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
                        .frame(width: 300, height: 60)
                        .background(Color.red)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                        .padding()
                }

            }
        }
    }
}

// MARK: - DateLabel

struct DateLabel: View {
    @State private var isDatePickerVisible = false
    @Binding var selectedDate: Date
    @State private var text: String = ""
    let lottieView: LottieAnimationView

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
                    .blendMode(.normal)
                    .onTapGesture {
                        isDatePickerVisible.toggle()
                    }
            }
            .onTapGesture {
                isDatePickerVisible.toggle()
            }

            if isDatePickerVisible {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.automatic)
                    .labelsHidden()
                    .onChange(of: selectedDate) { newValue in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .short
                        text = dateFormatter.string(from: newValue)
                        isDatePickerVisible = false
                    }
            }
        }
        .onAppear {
            lottieView.play { _ in
                // Animation completion handler
            }
            text = DateFormatter.localizedString(from: selectedDate, dateStyle: .medium, timeStyle: .short)
        }
    }
}
