import Foundation
import SwiftUI

public struct DesignSystem {
    
    // MARK: Fonts
    
    public static func registerFonts() {
        AppFont.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
      }
      
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
