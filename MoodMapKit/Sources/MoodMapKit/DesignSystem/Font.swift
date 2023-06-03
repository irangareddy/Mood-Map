//
//  Font.swift
//
//
//  Created by Ranga Reddy Nukala on 28/05/23.
//

import Foundation
import SwiftUI

/// Custom Fonts for App
public enum AppFont: String, CaseIterable {
    case DMSans = "DMSans-Regular"
    case PlayfairDisplay = "PlayfairDisplay-Regular"
}

/// Font size styling
extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 60
        case .title: return 48
        case .title2: return 34
        case .title3: return 24
        case .headline, .body: return 18
        case .subheadline, .callout: return 16
        case .footnote: return 14
        case .caption, .caption2: return 12
        @unknown default:
            return 8
        }
    }
}

public extension Font {

    // MARK: - Custom Fonts with DMSans

    /// The large title font style with DMSans.
    static let appLargeTitle: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.largeTitle.size)

    /// The title font style with DMSans.
    static let appTitle: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.title.size)

    /// The title 2 font style with DMSans.
    static let appTitle2: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.title2.size)

    /// The title 3 font style with DMSans.
    static let appTitle3: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.title3.size)

    /// The headline font style with DMSans.
    static let appHeadline: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.headline.size)

    // MARK: - Custom Fonts with DMSans

    /// The subheadline font style with DMSans.
    static let appSubheadline: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.subheadline.size)

    /// The body font style with DMSans.
    static let appBody: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.body.size)

    /// The callout font style with DMSans.
    static let appCallout: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.callout.size)

    /// The caption font style with DMSans.
    static let appCaption: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.caption.size)

    /// The caption 2 font style with DMSans.
    static let appCaption2: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.caption2.size)

    // MARK: - Additional Font Sizes

    /// The large body font style with DMSans.
    static let appLargeBody: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.body.size * 1.2)

    /// The small subheadline font style with DMSans.
    static let appSmallSubheadline: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.subheadline.size * 0.9)

    /// The large footnote font style with DMSans.
    static let appLargeFootnote: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.footnote.size * 1.2)

    // MARK: - Additional Custom Font Styles

    /// Creates a custom font with the specified size and weight for descriptive purposes.
    ///
    /// - Parameters:
    ///   - size: The size of the font.
    ///   - weight: The weight of the font.
    /// - Returns: A custom font with the specified size and weight.
    static func descriptive(size: CGFloat, weight: Font.Weight) -> Font {
        Font.custom(AppFont.DMSans.rawValue, size: size).weight(weight)
    }

    /// Creates a custom font with the specified size and weight for headline purposes.
    ///
    /// - Parameters:
    ///   - size: The size of the font.
    ///   - weight: The weight of the font.
    /// - Returns: A custom font with the specified size and weight.
    static func headliney(size: CGFloat, weight: Font.Weight) -> Font {
        Font.custom(AppFont.DMSans.rawValue, size: size).weight(weight)
    }

    // Define more font styles and sizes as needed
}

#if os(iOS)
import UIKit

extension UIFont {
    public static func AVQestFont(size: CGFloat) -> UIFont {
        UIFont(name: AppFont.PlayfairDisplay.rawValue, size: size)!
    }
}
#endif
