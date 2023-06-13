//
//  OnboardingView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 12/06/23.
//

import SwiftUI

/// Onboarding View
struct OnboardingView: View {

    /// current step in onboarding process
    @State var currentStep = 0

    init() {
        // stops screen bounce while paging
        UIScrollView.appearance().bounces = false
        // hides bootom tabbar
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        VStack {
            TabView(selection: $currentStep) {
                ForEach(0 ..< onboardingSteps.count, id: \.self) { index in
                    VStack {
                        onboardingSteps[index].image
                            .resizable()
                            .scaledToFit()
                            .frame(height: UIScreen.main.bounds.height/3)
                            .background(Color.accentColor)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            .shadow(color: Color.accentColor.opacity(0.3), radius: 20, x: 0, y: 10)
                            .shadow(color: Color.black.opacity(0.2), radius: 0.5)

                        Text(onboardingSteps[index].title)
                            .font(.appLargeBody)
                            .lineLimit(2)
                            .foregroundColor(Color.accentColor)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .padding(20)

                        Text(onboardingSteps[index].description)
                            .font(.appBody)
                            .lineSpacing(5)
                            .lineLimit(4)
                            .multilineTextAlignment(.center)
                            .padding(8)
                    }
                    .tag(index)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

            Spacer()

            StepView(currentStep: $currentStep)
                .padding(.top, 16)
                .padding(.bottom, 24)

            LargeButton(title: currentStep == 2 ? "Get Started" : "Next", disabled: false, backgroundColor: .accentColor, foregroundColor: .white) {
                if currentStep == 2 {
                    showLoginScreen()
                } else {
                    moveNext()
                }
            }

            SmallButton(title: "Skip", disabled: false, backgroundColor: .clear, foregroundColor: .accentColor, cornerRadius: 0) {
                showLoginScreen()
            }
        }

    }

    /// Change state of current step value
    func moveNext() {
        if currentStep < onboardingSteps.count - 1 {
            withAnimation(.easeOut(duration: 0.5)) {
                currentStep += 1
            }
        } else {
            withAnimation(.easeOut(duration: 0.5)) {
                currentStep = 0
            }
        }
    }

    func showLoginScreen() {

        NavigationController.pushController(UIHostingController(rootView: SignInView()))
    }
}

// Enable it to Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

// MARK: - StepView

/// A view that previews index of the current onboarding view
struct StepView: View {
    @Binding var currentStep: Int
    var body: some View {
        HStack {
            ForEach(0 ..< onboardingSteps.count, id: \.self) { index in
                if index == currentStep {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.accentColor)
                } else {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.accentColor).opacity(0.2)
                }
            }
        }
    }
}
