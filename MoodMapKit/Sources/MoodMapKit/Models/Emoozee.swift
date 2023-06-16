import Foundation
import SwiftUI

/// Represents the Emoozee package, which manages mood data and provides access to moods.
///
/// `Emoozee` is an `ObservableObject` class that holds the `moodData` and `placeholderMood` properties.
/// It provides methods to load mood data from JSON and retrieve moods.
public class Emoozee: ObservableObject {

    public static let shared = Emoozee()
    /// The mood data managed by Emoozee.
    @Published public var moodData: MoodData

    /// The placeholder mood used in Emoozee.
    @Published public var placeholderMood: Mood

    /// An error enum for bundle-related errors.
    public enum BundleError: Error {
        /// The file was not found.
        case fileNotFound
    }

    /// Initializes a new instance of Emoozee.
    public init() {
        let decoder = JSONDecoder()
        self.moodData = MoodData(moods: []) // Initialize moodData here
        self.placeholderMood = Mood(name: "", category: MoodCategory.highEnergyPleasant, happinessIndex: 0, intensityLevel: 0, emoji: "", description: "") // Initialize placeholderMood here

        if let mood = self.placeholderMoods().first {
            self.placeholderMood = mood
        }

        self.loadMoodData(decoder: decoder) // Call loadMoodData method after moodData initialization
    }

    /// Loads mood data from a JSON file using the provided decoder.
    ///
    /// - Parameter decoder: The JSON decoder to use for decoding.
    private func loadMoodData(decoder: JSONDecoder) {
        do {
            let data = try getJSONData(filename: "moods")
            moodData = try decoder.decode(MoodData.self, from: data)
        } catch {
            // Handle any errors here
            debugPrint("Failed to load mood data:", error)
        }
    }

    /// Retrieves JSON data from the specified file in the app bundle.
    ///
    /// - Parameter filename: The name of the JSON file.
    /// - Returns: The JSON data.
    /// - Throws: A `BundleError` if the file is not found.
    private func getJSONData(filename: String) throws -> Data {
        guard let path = Bundle.module.path(forResource: filename, ofType: "json") else {
            throw BundleError.fileNotFound
        }

        if #available(iOS 16.0, *) {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } else {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                throw BundleError.fileNotFound
            }
            return data
        }
    }

    /// Retrieves the mood at the specified index from the mood data.
    ///
    /// - Parameter index: The index of the mood.
    /// - Returns: The mood at the specified index, or `nil` if the index is out of bounds.
    public func getMood(at index: Int) -> Mood? {
        guard index >= 0 && index < moodData.moods.count else {
            return nil
        }
        return moodData.moods[index]
    }

    /// Retrieves an array of placeholder moods.
    ///
    /// - Returns: An array of shuffled placeholder moods.
    public func placeholderMoods() -> [Mood] {
        let shuffledMoods = moodData.moods.shuffled()
        let endIndex = min(40, shuffledMoods.count)
        if let firstMood = shuffledMoods.first {
            self.placeholderMood = firstMood
        }
        return Array(shuffledMoods[0..<endIndex])
    }
}
