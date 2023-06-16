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
    @ObservedObject var emoozee = Emoozee.shared
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

struct MoodCheckInView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    @StateObject private var moodVM = MoodViewModel.shared
    @ObservedObject var userPreferenceViewModel = UserPreferenceViewModel.shared

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
    @State var voiceNoteId: String?

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    topSection
                    DateLabel(selectedDate: $date, lottieView: lottieView(for: .edit))
                    PhotoPickerView(selectedUIImage: $picture, status: moodVM.isImageSaved)
                    VoiceNoteView(lottieView: lottieView(for: .microphoneRecording), voiceNoteId: $voiceNoteId, status: moodVM.isAudioSaved)
                    NoteView(notes: $notes, geometry: geometry)
                    TagsView(title: "Where are you?", cases: getAllRawValues(ofEnum: Place.self), lottieIcon: MoodMapAnimatedIcons.location, geometry: geometry, size: 5, selectedValue: $place)
                    TagsView(title: "Weather", cases: getAllRawValues(ofEnum: Weather.self), lottieIcon: MoodMapAnimatedIcons.weather, geometry: geometry, size: 5, selectedValue: $weather)
                        .padding(.top, 8)
                    ExerciseView(lottieView: lottieView(for: .exercise), exerciseHours: $exerciseHours)
                    SleepView(lottieView: lottieView(for: .sleep), sleepHours: $sleepHours)
                }
                .padding()
            }
            .redacted(reason: selectedMood == nil ? .placeholder : [])
            .safeAreaInset(edge: .bottom) {
                FloatingButton(action: {
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
                    if let pictureId = await moodVM.saveImage(loaded: newImage) {
                        self.imageId = pictureId
                    }
                }
            }
        }.onAppear {
            userPreferenceViewModel.loadAccentColor()
        }
    }

    private var topSection: some View {
        VStack(alignment: .leading) {
            Text("I'm feeling")
            Text(selectedMood?.name ?? Emoozee.shared.placeholderMood.name)
                .foregroundColor(getMoodCategoryColor(for: MoodCategory(rawValue: (selectedMood?.name.toMood()?.category)!.rawValue) ?? .highEnergyPleasant))
        } .font(.appTitle2)
        .multilineTextAlignment(.leading)
    }

    private func createEntry() {
        guard let selectedMood = selectedMood else {
            print("No selected mood")
            return
        }

        let weatherEnum: Weather? = Weather.allCases.first { $0.rawValue == weather.lowercased() }
        let placeEnum: Place? = Place.allCases.first { $0.rawValue == place.lowercased() }

        let exerciseHoursInt = Double(exerciseHours)
        let sleepHoursInt = Double(sleepHours)

        let moodEntry = MoodEntry(
            moods: [selectedMood],
            timestamp: date,
            imageId: imageId,
            voiceNoteId: voiceNoteId,
            notes: notes,
            place: placeEnum,
            exerciseHours: exerciseHoursInt,
            sleepHours: sleepHoursInt,
            weather: weatherEnum
        )

        moodVM.append(mood: moodEntry) {
            // Completion handler called after appending the moodEntry
            // Handle any necessary actions or UI updates
        }
    }
}

// MARK: - VoiceNoteView

struct VoiceNoteView: View {
    let lottieView: LottieAnimationView?
    @State private var isPresentingSheet = false
    @Binding var voiceNoteId: String?
    var status: Bool?

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("Add a voice note")
                    .font(.appBody)
                Spacer()
                HStack {
                    if status == false {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    Image(systemName: status == true ? "checkmark.circle.fill" : "mic")
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            isPresentingSheet = true
                        }
                }

                .sheet(isPresented: $isPresentingSheet) {
                    // Present your sheet view here
                    // Replace `YourSheetView()` with your actual sheet view implementation
                    AudioContentView(id: $voiceNoteId, recorderView: true).presentationDetents([.height(200)])
                }
            }
            .padding(.vertical, 2)
            Divider()
        }
    }
}

// MARK: - NOTE VIEW

struct NoteView: View {
    @Binding var notes: String
    var geometry: GeometryProxy
    let lottieView = LottieAnimationView(name: MoodMapAnimatedIcons.document.fileName, bundle: .main)

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Add a note")
                    .font(.appBody)
                Spacer()
                //                ResizableLottieView(lottieView: lottieView, color: Color.accentColor)
                Image(systemName: "note")
                    .frame(width: 30, height: 30)
                    .foregroundColor(.accentColor)
                    .onAppear {
                        DispatchQueue.main.async {
                            lottieView.play { _ in
                                // Animation completion handler
                            }
                        }
                    }
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

                Image(systemName: "figure.gymnastics")
                    .frame(width: 30, height: 30)
                    .foregroundColor(.accentColor)
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
                Image(systemName: "sleep")
                    .frame(width: 30, height: 30)
                    .foregroundColor(.accentColor)
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
//
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

// struct PhotoPickerView: View {
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
// }

struct PhotoPickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @Binding var selectedUIImage: UIImage?
    @State private var showActionSheet = false
    @State private var selectedOption: PhotoActions?
    var status: Bool?
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
                    .overlay {
                        ZStack {
                            if status == false {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                            if status == true {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding()

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
                            //                            ResizableLottieView(lottieView: lottieView, color: Color.accentColor, loopMode: .loop)
                            Image(systemName: "photo")
                                .frame(width: 30, height: 30)
                                .onAppear {
                                    DispatchQueue.main.async {
                                        lottieView.play { _ in
                                            // Animation completion handler
                                        }
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
                LargeButton(title: "Save", action: action)
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
                //                ResizableLottieView(lottieView: lottieView, color: Color.accentColor)
                Image(systemName: "pencil")
                    .font(.subheadline)
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.accentColor)
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
