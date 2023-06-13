//
//  SplashScreen.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 09/06/23.
//

import SwiftUI

func clearStoredValues() {
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()

}

struct SplashScreen: View {
    @ObservedObject private var authManager = AuthViewModel.shared
    @State private var isActive = false

    var body: some View {
        VStack {
            if isActive {
                if authManager.isUserLoggedIn {
                    TabbedView()
                        .onAppear(perform: clearStoredValues)
                } else {
                    SignInView()
                }
            } else {
                Text("Appwrite CRUD")
                    .font(.largeTitle)
                    .opacity(0.5)
                    .animation(.easeInOut(duration: 1))
                    .onAppear {
                        authManager.validateCurrentSession()
                        withAnimation {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.isActive = true
                            }
                        }
                    }
            }

        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
