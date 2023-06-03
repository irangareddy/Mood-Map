//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

/// An extension that provides a modifier to obtain the offset of a view within a specified coordinate space.
extension View {

    /// Modifies the view to capture its offset within a coordinate space and invoke a completion closure with the resulting rectangle.
    ///
    /// - Parameter completion: A closure to be invoked with the resulting rectangle representing the offset of the view.
    ///
    /// - Returns: A modified view that captures its offset within a coordinate space and invokes the provided closure.
    ///
    /// - Note: The resulting rectangle represents the frame of the view within the specified coordinate space.
    ///
    /// - SeeAlso: `GeometryReader`, `PreferenceKey`
    @ViewBuilder
    public func offset(completion: @escaping (CGRect) -> Void) -> some View {
        self.overlay {
            GeometryReader { geometry in
                let rect = geometry.frame(in: .named("SCROLLER"))
                Color.clear
                    .preference(key: OffsetKey.self, value: rect)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}
