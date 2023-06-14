//
//  UserPreferenceViewModel.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 13/06/23.
//

import SwiftUI

class UserPreferenceViewModel: ObservableObject {
    static let shared = UserPreferenceViewModel()
    @AppStorage("colorScheme") var chosenColorScheme: ColorSchemeSetting = .system
    @AppStorage("appAccentColorData") private var appAccentColorData: Data?
    @Published var selectedColor: Color = .accentColor

    var selectedColorScheme: ColorScheme? {
        switch chosenColorScheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }

    init() {
        loadAccentColor()
    }

    func saveAccentColor(_ color: Color) {
        let codableColor = CodableColor(color)
        let accentColorData = try? JSONEncoder().encode(codableColor)
        UserDefaults.standard.set(accentColorData, forKey: "appAccentColorData")
    }

    public func loadAccentColor() {
        if let accentColorData = UserDefaults.standard.data(forKey: "appAccentColorData"),
           let codableColor = try? JSONDecoder().decode(CodableColor.self, from: accentColorData) {
            selectedColor = codableColor.color
            updateAppAccentColor(selectedColor)
        }
    }

    #if os(iOS)
    public func updateAppAccentColor(_ color: Color) {
        UIApplication.shared.windows.first?.tintColor = UIColor(color)
    }
    #endif
}
