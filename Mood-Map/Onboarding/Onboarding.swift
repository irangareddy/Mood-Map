//
//  Onboarding.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 12/06/23.
//

import Foundation
import SwiftUI

// MARK: - Onboarding

/// [Model] Onboarding Step for Intro Screens
struct OnboardingStep {
    var id = UUID().uuidString
    var image: Image
    var title: String
    var description: String
}

/// Onboarding Steps Collection
let onboardingSteps: [OnboardingStep] =
    [
        OnboardingStep(
            image: Image("step-one"),
            title: "Track Your Moods",
            description: "Effortlessly log your moods and emotions throughout the day and gain insights into your emotional patterns and well-being."
        ),
        OnboardingStep(
            image: Image("step-two"),
            title: "Get Insights and Analysis",
            description: "Gain a deeper understanding of your emotions with Mood Map's powerful analysis features and valuable insights for your emotional growth."
        ),
        OnboardingStep(
            image: Image("step-three"),
            title: "One Step Closer to Well-Being",
            description: "Take meaningful steps towards a happier and healthier life by tracking your moods, gaining insights, and making positive changes."
        )
    ]
