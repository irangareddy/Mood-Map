//
//  TabView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import MoodMapKit
import Lottie
import SwiftUI

// MARK: - TabbedView

struct TabbedView: View {

    init() {
        UITabBar.appearance().isHidden = true
    }

    // MARK: View Properties

    @State var selectedTab: Tab = .checkIn

    @State var animatedIcons: [AnimatedIcon] = {
        var tabs: [AnimatedIcon] = []
        for tab in Tab.allCases {
            tabs.append(AnimatedIcon.init(tab: tab, lottieView: LottieAnimationView(name: tab.fileName, bundle: .main)))
        }
        return tabs
    }()

    @Environment(\.colorScheme) var scheme

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {

                Group {
                    switch selectedTab {
                    case .checkIn:
                        CheckInView()
                    case .memoryLane:
                        MemoryLaneViewWrapper()
                    case .moodInsights:
                        MoodInsightsView()
                    case .settings:
                        SettingsView()
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)

                if #available(iOS 16, *) {
                    TabBar()
                        .toolbar(.hidden, for: .tabBar)
                } else {
                    TabBar()
                }

            }
        }
    }

}

struct TabbedView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedView()
    }
}

extension TabbedView {
    /// The tab bar view representing the tabs in the TabbedView.
    ///
    /// This view displays a horizontal stack of tab items, each consisting of a resizable Lottie animation
    /// view and a text label representing the tab name. The appearance of the tab items is determined based
    /// on the current selected tab.
    ///
    /// - Returns: A view representing the tab bar.
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(animatedIcons) { icon in
                TabBarItem(icon: icon)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 14)
        .frame(height: 88, alignment: .top)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
        .background(HStack {
            if selectedTab == .settings { Spacer() }
            if selectedTab == .memoryLane { Spacer() }
            if selectedTab == .moodInsights { Spacer()
                Spacer() }
            Circle().fill(Color(hex: "#734f96")).frame(width: 80)
            if selectedTab == .checkIn { Spacer() }
            if selectedTab == .memoryLane { Spacer()
                Spacer() }
            if selectedTab == .moodInsights { Spacer() }
        }.padding(.horizontal, 8))
        .overlay(HStack {
            if selectedTab == .settings { Spacer() }
            if selectedTab == .memoryLane { Spacer() }
            if selectedTab == .moodInsights { Spacer()
                Spacer() }
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#734f96")).frame(width: 28, height: 5)
                .frame(width: 88)
                .frame(maxHeight: .infinity, alignment: .top)
            if selectedTab == .checkIn { Spacer() }
            if selectedTab == .memoryLane { Spacer()
                Spacer() }
            if selectedTab == .moodInsights { Spacer() }
        }.padding(.horizontal, 8))
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}

extension TabbedView {
    /// Represents an individual tab item in the tab bar.
    ///
    /// This view combines a resizable Lottie animation view and a text label representing the tab name.
    /// The appearance of the tab item is determined based on the current selected tab.
    ///
    /// - Parameter icon: The `AnimatedIcon` representing the tab item.
    /// - Returns: A view representing the tab item.
    private func TabBarItem(icon: AnimatedIcon) -> some View {
        let tabColor: SwiftUI.Color = selectedTab == icon.tab ? .primary : .secondary

        return VStack(spacing: 0) {
            ResizableLottieView(lottieView: icon.lottieView, color: tabColor)
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
            Text(icon.tab.tabName)
                .font(.appCaption2)
        }
        .frame(maxWidth: .infinity)
        .contentShape(RoundedRectangle(cornerRadius: 34))
        .blendMode(selectedTab == icon.tab ? .overlay : .normal)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = icon.tab
                icon.lottieView.play { _ in
                }
            }
        }
    }
}
