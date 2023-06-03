//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

/// A preference key representing a rectangle used to capture the offset of a view within a coordinate space.
struct OffsetKey: PreferenceKey {
    /// The default value for the offset rectangle.
    static var defaultValue: CGRect = .zero

    /// Combines the value of the offset rectangles.
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
