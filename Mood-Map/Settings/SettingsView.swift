//
//  SettingsView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 30/05/23.
//

import SwiftUI
import MoodMapKit
#if os(iOS)
import UIKit
import MessageUI
#endif
enum ColorSchemeSetting: String, CaseIterable {
    case light, dark, system
}

struct CodableColor: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double

    init(_ color: Color) {
        #if os(iOS)
        let uiColor = UIColor(color)
        red = Double(uiColor.cgColor.components?[0] ?? 0)
        green = Double(uiColor.cgColor.components?[1] ?? 0)
        blue = Double(uiColor.cgColor.components?[2] ?? 0)
        opacity = Double(uiColor.cgColor.alpha)
        #endif
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct SettingsView: View {
    @AppStorage("colorScheme") var chosenColorScheme: ColorSchemeSetting = .system
    @AppStorage("appAccentColorData") private var appAccentColorData: Data?
    @State private var selectedColor = Color.accentColor

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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WaveDividerView()
            VStack(alignment: .leading) {
                Text("Appearence".capitalized)
                    .font(.appSmallSubheadline)
                // Color Picker
                Picker(selection: $chosenColorScheme, label: Text("Choose scheme")) {
                    ForEach(ColorSchemeSetting.allCases, id: \.self) { colorScheme in
                        Text(colorScheme.rawValue.capitalized)
                            .font(.appCaption)
                    }
                }
                .pickerStyle(.segmented)

                // Footer
                Text("Select a color scheme for your app")
                    .font(.appCaption)
                    .foregroundColor(.secondary)

                ColorPicker("Select an accent color", selection: $selectedColor)
                    .font(.appSmallSubheadline)
                    .onChange(of: selectedColor) { newValue in
                        saveAccentColor(newValue)
                        #if os(iOS)
                        updateAppAccentColor(newValue)
                        #endif
                    }
                Text("Select a accent color for your app")
                    .font(.appCaption)
                    .foregroundColor(.secondary)
            }.padding()
            WaveDividerView()
            Group {
                VStack(alignment: .leading) {
                    Text("General")
                        .font(.appSmallSubheadline)
                        .padding()
                    NavigationButton(destination: HomeView(), label: "Profile", systemImage: "person")
                    NavigationButton(destination: AccountSettingsView(), label: "Account Settings", systemImage: "person")
                    NavigationButton(destination: NotificationsScreen(reminders: []), label: "Notifications", systemImage: "bell")
                    NavigationButton(destination: AboutView(), label: "About", systemImage: "info.bubble")
                    #if os(iOS)
                    MailButton()
                    #endif
                }

            }.padding(.top, 4)

            Spacer()
        }
        .navigationTitle("Settings")
        .preferredColorScheme(selectedColorScheme)
        .onAppear {
            loadAccentColor()
            #if os(iOS)
            updateAppAccentColor(selectedColor)
            #endif
        }

    }

    private func saveAccentColor(_ color: Color) {
        let codableColor = CodableColor(color)
        let accentColorData = try? JSONEncoder().encode(codableColor)
        UserDefaults.standard.set(accentColorData, forKey: "appAccentColorData")
    }

    private func loadAccentColor() {
        if let accentColorData = UserDefaults.standard.data(forKey: "appAccentColorData"),
           let codableColor = try? JSONDecoder().decode(CodableColor.self, from: accentColorData) {
            selectedColor = codableColor.color
        }
    }
    #if os(iOS)

    private func updateAppAccentColor(_ color: Color) {
        UIApplication.shared.windows.first?.tintColor = UIColor(color)
    }
    #endif

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()

            SettingsView()
                .preferredColorScheme(.dark)
        }
    }
}

struct AccentColorButton: View {
    @State var appAccentColor: Color = .black

    var body: some View {
        Button(action: {
            // Handle button action if needed
        }) {
            HStack {
                Image(systemName: "paintbrush.fill")
                    .padding(.trailing, 8)

                Text("Change Accent Color")
                    .font(.headline)

                Spacer()

                Rectangle()
                    .fill(appAccentColor)
                    .frame(width: 20, height: 20)
                    .cornerRadius(4)
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .foregroundColor(.primary)
        }
        .buttonStyle(NavigationButtonStyle())
        .sheet(isPresented: .constant(true)) {
            ColorPicker("Color", selection: $appAccentColor)
        }
    }
}
#if os(iOS)
struct MailButton: View {
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var isShowingMailView = false

    var body: some View {
        Button(action: {
            self.isShowingMailView.toggle()
        }) {
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.accentColor)
                    .padding(.trailing, 8)

                Text("Share Feedback")
                    .font(.appHeadline)

                Spacer()

                Image(systemName: "arrow.right")
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .foregroundColor(.primary)
        }
        .buttonStyle(NavigationButtonStyle())
        .disabled(!MFMailComposeViewController.canSendMail())
        .sheet(isPresented: $isShowingMailView) {
            //            MailView(result: self.$result)
        }
    }
}
#endif

struct NavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.secondary.opacity(0.2) : Color.clear)
            .cornerRadius(8)
            .padding(.vertical, 4)
    }
}

struct WaveformDivider: View {
    let amplitude: CGFloat
    let frequency: CGFloat
    let phase: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let step = 5 // Number of points to create the waveform
                let width = geometry.size.width
                let height = geometry.size.height

                let yCenter = height / 2
                let yAmplitude = amplitude * height / 2

                path.move(to: CGPoint(x: 0, y: yCenter))

                for x in stride(from: 0, through: width, by: CGFloat.Stride(step)) {
                    let angle = (x / width) * frequency * 2 * .pi + phase
                    let y = yCenter + sin(angle) * yAmplitude

                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.gray, lineWidth: 1)
        }
    }
}

struct WaveDividerView: View {
    private let waveformDividerAmplitude: CGFloat = 0.5
    private let waveformDividerFrequency: CGFloat = 100
    private let waveformDividerPhase: CGFloat = 0.0

    var body: some View {
        WaveformDivider(amplitude: waveformDividerAmplitude,
                        frequency: waveformDividerFrequency,
                        phase: waveformDividerPhase)
            .frame(height: 10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: -5)
            .shadow(color: Color.black.opacity(0.2), radius: -5, x: -5, y: 5)

    }
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }

        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window

    }
}
