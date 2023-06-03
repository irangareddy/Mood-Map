//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

/// Returns a linear gradient representing the color associated with the given mood category.
///
/// - Parameter category: The mood category.
/// - Returns: A linear gradient representing the color associated with the given mood category.
public func getCategoryColor(for category: MoodCategory?) -> LinearGradient {
    guard let category = category else {
        return LinearGradient(gradient: Gradient(colors: [Color.gray]), startPoint: .leading, endPoint: .trailing)
    }

    switch category {
    case .highEnergyPleasant:
        return LinearGradient(gradient: Gradient(colors: [Color(hex: "0061ff"), Color(hex: "60Efff")]), startPoint: .bottomLeading, endPoint: .topTrailing)
    case .highEnergyUnpleasant:
        return LinearGradient(gradient: Gradient(colors: [Color(hex: "ff930f"), Color(hex: "fff95b")]), startPoint: .bottomLeading, endPoint: .topTrailing)
    case .lowEnergyPleasant:
        return LinearGradient(gradient: Gradient(colors: [Color(hex: "9796F0"), Color(hex: "fbc7d4")]), startPoint: .bottomLeading, endPoint: .topTrailing)
    case .lowEnergyUnpleasant:
        return LinearGradient(gradient: Gradient(colors: [Color(hex: "ff0f7B"), Color(hex: "f89b29")]), startPoint: .bottomLeading, endPoint: .topTrailing)
    }
}
