//
//  LottieView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 03/06/23.
//

import Foundation
import SwiftUI
import MoodMapKit
import Lottie

/// A SwiftUI representation of a resizable Lottie animation view.
public struct ResizableLottieView: UIViewRepresentable {
    var lottieView: LottieAnimationView!
    var color: SwiftUI.Color = Color.black
    var loopMode: LottieLoopMode

    public init(lottieView: LottieAnimationView!, color: SwiftUI.Color, loopMode: LottieLoopMode = .loop) {
        self.lottieView = lottieView
        self.color = color
        self.loopMode = loopMode
    }

    public func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView()
        view.backgroundColor = .clear
        view.loopMode = loopMode
        addLottieView(to: view)
        return view
    }

    public func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // MARK: DYNAMIC COLOR UDPATE
        // Finding attached lottie view
        if let animationView = uiView.subviews.first(where: { view in
            view is LottieAnimationView
        }) as? LottieAnimationView {
            // MARK: Finding KeyPaths with the help of log
            // lottieView.logHierarchyKeypaths()

            let lottieColor = ColorValueProvider(UIColor(color).lottieColorValue)

            let keyPaths = ["Fill 1", "Stroke 1"]
            for key in keyPaths {
                let keyPath = AnimationKeypath(keys: ["**", key, "**", "Color"])
                animationView.setValueProvider(lottieColor, keypath: keyPath)
            }
        }
    }

    /// Adds the Lottie animation view to the given view.
    /// - Parameter view: The view to which the Lottie animation view will be added.
    func addLottieView(to view: LottieAnimationView) {
        // MARK: Memory Properties
        lottieView.backgroundBehavior = .forceFinish
        lottieView.shouldRasterizeWhenIdle = true

        lottieView.backgroundColor = .clear
        lottieView.contentMode = .scaleAspectFit
        lottieView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: view.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]

        view.addSubview(lottieView)
        view.addConstraints(constraints)
    }
}

/// Represents an animated icon associated with a tab.
public struct AnimatedIcon: Identifiable {
    /// The unique identifier of the animated icon.
    public var id: String

    /// The tab associated with the animated icon.
    public var tab: Tab

    /// The Lottie animation view for the icon.
    public var lottieView: LottieAnimationView

    /// Initializes an animated icon with the specified parameters.
    /// - Parameters:
    ///   - id: The unique identifier of the animated icon. Defaults to a generated UUID string.
    ///   - tab: The tab associated with the animated icon.
    ///   - lottieView: The Lottie animation view for the icon.
    public init(id: String = UUID().uuidString, tab: Tab, lottieView: LottieAnimationView) {
        self.id = id
        self.tab = tab
        self.lottieView = lottieView
    }
}
