import Foundation
import SwiftUI

public struct DesignSystem {

    // MARK: Fonts

    public static func registerFonts() {
        AppFont.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }
    #if os(iOS)
    public static func registerAppaerance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.AVQestFont(size: 32)]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.AVQestFont(size: 20)]
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.AVQestFont(size: 14)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.AVQestFont(size: 17)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.AVQestFont(size: 14)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.AVQestFont(size: 15)], for: .selected)

    }
    #endif
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data \(fontName).\(fontExtension) at \(Bundle.main.bundlePath)")
        }

        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }

}
