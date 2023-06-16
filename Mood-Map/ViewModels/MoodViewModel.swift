//
//  NoteViewModel.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 16/05/23.
//

import SwiftUI
import Combine
import AppwriteModels
import AVFoundation
import NIO
import MoodMapKit

class MoodViewModel: BaseViewModel {
    static let shared = MoodViewModel()
    private let authVM = AuthViewModel.shared
    @Published var moodEntries = [AppwriteModels.Document<MoodEntry>]()
    @Published var error: NetworkError?
    @Published var image: Image?
    @Published var recording: Recording?
    @Published var isAudioSaved: Bool?
    @Published var isImageSaved: Bool?

    private var networkManager = NetworkManager.shared

    override init() {
        super.init()
        Task { try? await getMoods() }
    }

    // MARK: MOOD CREATE
    func append(mood: MoodEntry, completion: @escaping () -> Void) {
        updateLoading(true)

        Task {
            do {
                try await networkManager.createDocument(collectionId: K.MOOD_ENTRIES_COLLECTION_ID, data: mood, permissions: [])
                completion()
                await getMoods()
            } catch {
//                if error as! UserDefaultsError {
                    await authVM.logout()
//                }
                debugPrint("Got error here \(dump(error))")
                handleAppError(error)
            }

        }
        updateLoading(false)

    }

    // MARK: MOOD READ
    func getMoods() async {
        updateLoading(true)

        do {
            let response = try await networkManager.readDocuments(collectionId: K.MOOD_ENTRIES_COLLECTION_ID) as [AppwriteModels.Document<MoodEntry>]
            DispatchQueue.main.async {
                self.moodEntries = response
            }

        } catch {
            // Handle network request error
            self.error = NetworkError.dataConversionError
            handleAppError(error) // Set isLoading to false in case of an error
        }
        updateLoading(false)
    }

    // MARK: MOOD DELETE
    func delete(of document: Document<MoodEntry>) async {
        isLoading = true // Set isLoading to true before making the network request

        do {
            _ = try await networkManager.deleteDocument(collectionId: K.MOOD_ENTRIES_COLLECTION_ID, documentId: document.id)

        } catch {
            // Handle network request error
            self.error = NetworkError.dataConversionError
            isLoading = false // Set isLoading to false in case of an error
        }

    }

    func saveImage(loaded: UIImage?) async -> String? {
        DispatchQueue.main.async { [self] in
            isImageSaved = false
        }
        if let image = loaded {
            if let processedImage = processImage(image: image, maxSizeInMB: 3.0) {
                let imageData = processedImage.data
                let fileExtension = processedImage.extension

                // Process the image data and file extension as needed
                debugPrint("Processed image data size: \(Double(imageData.count) / (1024 * 1024)) MB")
                debugPrint("File extension: \(fileExtension.rawValue) mimetype: image/\(fileExtension.rawValue) ")
                do {
                    let response = try await networkManager.saveImageInStorage(imageData, fileName: "football.\(fileExtension.rawValue)", mime: "\(fileExtension.rawValue)")
                    DispatchQueue.main.async { [self] in
                        isImageSaved = true
                    }
                    return response.id
                } catch {
                    handleAppError(error)
                }

            } else {
                // Failed to process the image
                debugPrint("Failed to convert image to data")
            }
        } else {
            // Failed to load the image
            debugPrint("Failed to load the image")
        }
        return nil
    }

    // MARK: GET IMAGE

    func getImage(of id: String) async -> Image? {
        do {
            if let buffer = try await networkManager.preview(fileId: id) {
                let image = Image(uiImage: UIImage(data: Data(buffer: buffer))!)
                return image
            }
        } catch {
            debugPrint("On get Image")
        }
        return nil
    }

    // MARK: GET AUDIO
    func getVoiceNote(of id: String) async -> Recording? {
        do {
            if let buffer = try await networkManager.previewAudio(fileId: id) {
                let location = fileLocationWithByteBuffer(buffer)
                let recording = Recording(name: "Now Playing", location: location)
                return recording
            }
        } catch {
            debugPrint("On get Image")
        }
        return nil
    }

    func saveAudioRecording(fileURL: URL) async -> String? {
        DispatchQueue.main.async { [self] in
            isAudioSaved = false
        }

        var fileData: Data
        do {
            fileData = try Data(contentsOf: fileURL)
        } catch {
            debugPrint("Error reading file data: \(error.localizedDescription)")
            handleAppError(error)
            return nil
        }

        do {
            let response = try await networkManager.saveAudio(fileData)
            DispatchQueue.main.async { [self] in
                isAudioSaved = true
            }
            return response
        } catch {
            handleAppError(error)
            return nil
        }
    }
}

func fileLocationWithByteBuffer(_ byteBuffer: ByteBuffer) -> URL? {
    let data = Data(buffer: byteBuffer)

    // Check if the data is empty
    guard !data.isEmpty else {
        // Handle empty data error
        return nil
    }

    // Save the data to a temporary file
    let fileManager = FileManager.default
    let temporaryDirectoryURL = fileManager.temporaryDirectory
    let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent("tempFile.wav")

    do {
        // Write the data to the temporary file
        try data.write(to: temporaryFileURL, options: .atomic)

        // Read the saved file data
        let savedData = try Data(contentsOf: temporaryFileURL)

        // Compare the original data and the saved data
        if data == savedData {
            return temporaryFileURL
        } else {
            // Handle data integrity check failure
            return nil
        }
    } catch {
        // Handle file writing error
        return nil
    }
}

func saveResponseToJSON(response: String, fileName: String) {
    do {
        let data = response.data(using: .utf8)

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            try data?.write(to: fileURL)
            debugPrint("Response saved to file: \(fileURL.absoluteString)")
        }
    } catch {
        debugPrint("Error saving response to JSON file: \(error.localizedDescription)")
    }
}

enum FileExtension: String {
    case png
    case jpeg
}

func processImage(image: UIImage, maxSizeInMB: Double) -> (data: Data, extension: FileExtension)? {
    guard let imageData = image.pngData() else {
        debugPrint("Failed to convert image to data")
        return nil
    }

    let fileSize = Double(imageData.count) / (1024 * 1024) // Convert to MB

    guard fileSize > maxSizeInMB else {
        debugPrint("Image size is within the limit")
        return (data: imageData, extension: .png)
    }

    // Scale down the image if it exceeds the limit
    let scale: CGFloat = CGFloat(maxSizeInMB / fileSize)
    guard let resizedImage = image.resized(to: CGSize(width: image.size.width * scale, height: image.size.height * scale)),
          let resizedImageData = resizedImage.jpegData(compressionQuality: 0.8) else {
        debugPrint("Failed to resize image")
        return nil
    }

    debugPrint("Image was scaled down to fit the size limit")
    return (data: resizedImageData, extension: .jpeg)
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

// MARK: DEBUG
//            do {
//                let documents = try decoder.decode([ResponseModel].self, from: jsonResponse.description.data(using: .utf8)!)
//                // Process the decoded documents
////                self.moodEntries = documents.documents
//                dump(documents.count)
//                isLoading = false // Set isLoading to false after successful decoding
//
//            } catch let error as DecodingError {
//                switch error {
//                case .typeMismatch(let key, let value):
//                    debugPrint("\n---> typeMismatch key: \(key)  value: \(value)")
//                case .valueNotFound(let key, let value):
//                    debugPrint("\n---> valueNotFound key: \(key)  value: \(value)")
//                case .keyNotFound(let key, let value):
//                    debugPrint("\n---> keyNotFound key: \(key)  value: \(value)")
//                case .dataCorrupted(let key):
//                    debugPrint("\n---> dataCorrupted key: \(key)")
//                @unknown default:
//                    debugPrint("\n---> default error: \(error.localizedDescription)")
//                }
//
//                // Handle decoding error
//                self.error = NetworkError.decodingError
//                isLoading = false // Set isLoading to false in case of an error
//            } catch {
//                debugPrint("Decoding error: \(error)")
//                // Handle decoding error
//                self.error = NetworkError.decodingError
//                isLoading = false // Set isLoading to false in case of an error
//            }
