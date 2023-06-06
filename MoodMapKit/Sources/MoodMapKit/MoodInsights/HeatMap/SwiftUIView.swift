//
//  SwiftUIView.swift
//
//
//  Created by Ranga Reddy Nukala on 06/06/23.
//

import SwiftUI

// MARK: - Life Factors View

/// A `View` representing a single life factor.
///
/// `LifeFactorButton` is a public SwiftUI view that displays information about a life factor.
/// This includes the factor's display name, average hours, and total hours. It also acts as a button,
/// which updates a binding to the currently selected life factor when clicked.
///
/// A selected `LifeFactorButton` is highlighted with an accent color, while a deselected view has a white background.
///
/// - Note: The actual color values for selected and deselected states may depend on the color scheme of your app.
public struct LifeFactorButton: View {
    /// The life factor represented by the view.
    public let lifeFactor: LifeFactors

    /// The average hours associated with the life factor.
    public let averageHours: String

    /// The total hours associated with the life factor.
    public let totalHours: String

    /// A binding to the currently selected life factor.
    @Binding public var displayFactor: LifeFactors?

    /// The body of the `LifeFactorButton`.
    public var body: some View {
        Button(action: {
            // Update the selected life factor when the button is clicked.
            displayFactor = lifeFactor
        }) {
            HStack {
                Text(lifeFactor.displayName)
                    .font(.appBody)
                    .padding(.vertical, 4)

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Average: \(averageHours)")
                    Text("Total: \(totalHours)")
                }
                .font(.appSmallSubheadline)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                            .foregroundColor(displayFactor == lifeFactor ? Color.accentColor : Color.white))
        }
    }

    /// Creates a `LifeFactorButton`.
    ///
    /// - Parameters:
    ///     - lifeFactor: The life factor to display.
    ///     - averageHours: The average hours associated with the life factor.
    ///     - totalHours: The total hours associated with the life factor.
    ///     - displayFactor: A binding to the currently selected life factor.
    public init(lifeFactor: LifeFactors, averageHours: String, totalHours: String, displayFactor: Binding<LifeFactors?>) {
        self.lifeFactor = lifeFactor
        self.averageHours = averageHours
        self.totalHours = totalHours
        self._displayFactor = displayFactor
    }
}

struct LifeFactorButton_Previews: PreviewProvider {
    @State static var displayFactor: LifeFactors?

    static var previews: some View {
        LifeFactorButton(lifeFactor: .exercise,
                         averageHours: "2 hrs",
                         totalHours: "14 hrs",
                         displayFactor: $displayFactor)
    }
}
