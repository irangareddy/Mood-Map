//
//  NavigationController.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 11/06/23.
//

import Foundation
import SwiftUI
import UIKit

/// A utility struct that provides common navigation-related operations.
public struct NavigationController {

    /// Sets the root view controller of the key window.
    ///
    /// - Parameter viewController: The view controller to set as the root.
    public static func rootView(_ viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }

    /// Dismisses the topmost view controller from the navigation stack.
    public static func popView() {
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?.dismiss(animated: true)
    }

    /// Pops the current view controller to the root view controller.
    public static func popToRootView() {
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
            .popToRootViewController(animated: true)
    }

    /// Pushes a view controller onto the navigation stack.
    ///
    /// - Parameter controller: The view controller to push.
    public static func pushController(_ controller: UIViewController) {
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)!.pushViewController(controller, animated: true)
    }

    /// Presents a view controller as a full-screen modal.
    ///
    /// - Parameter controller: The view controller to present.
    public static func presentFullScreen(_ controller: UIViewController) {
        controller.modalPresentationStyle = .fullScreen
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)!.present(controller, animated: true)
    }

    // MARK: - Core Logic

    /// Allows performing actions with the current navigation controller.
    ///
    /// - Parameter action: A closure that takes the current navigation controller as a parameter.
    public static func navigationAction(_ action: ((UINavigationController) -> Void)) {
        action(findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)!)
    }

    /// Recursively finds the navigation controller in the view hierarchy.
    ///
    /// - Parameter viewController: The view controller to start the search from.
    /// - Returns: The found navigation controller, or nil if not found.
    private static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }

        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }

        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }

        return nil
    }
}

extension UIApplication {

    /// The key window currently being displayed.
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
