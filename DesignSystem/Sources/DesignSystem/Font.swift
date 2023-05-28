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
    
    // Font styles with DMSans
    static let appLargeTitle: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.largeTitle.size)
    static let appTitle: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.title.size)
    static let appTitle2: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.title2.size)
    static let appTitle3: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.title3.size)
    static let appHeadline: Font = .custom(AppFont.PlayfairDisplay.rawValue, size: Font.TextStyle.headline.size)
    
    // Font styles with DMSans
    static let appSubheadline: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.subheadline.size)
    static let appBody: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.body.size)
    static let appCallout: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.callout.size)
    static let appCaption: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.caption.size)
    static let appCaption2: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.caption2.size)
    
    // Additional font sizes for existing font styles
    static let appLargeBody: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.body.size * 1.2)
    static let appSmallSubheadline: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.subheadline.size * 0.9)
    static let appLargeFootnote: Font = .custom(AppFont.DMSans.rawValue, size: Font.TextStyle.footnote.size * 1.2)
    
    // Define more font styles and sizes as needed
    
    static func descriptive(size: CGFloat, weight: Font.Weight) -> Font {
        Font.custom(AppFont.DMSans.rawValue, size: size).weight(weight)
    }
    
    static func headliney(size: CGFloat, weight: Font.Weight) -> Font {
        Font.custom(AppFont.DMSans.rawValue, size: size).weight(weight)
    }
}

