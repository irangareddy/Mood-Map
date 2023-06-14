//
//  SignInView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 13/06/23.
//

import SwiftUI
import MoodMapKit

struct SignInView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    @State private var email: String = "test@gmail.com"
    @State private var password: String = "12345678"
    @State private var isShowingSignup: Bool = false
    @State private var isShowingForgotPassword: Bool = false
    @ObservedObject private var authVM = AuthViewModel.shared

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    Text("SignIn to Mood Map")
                        .font(.appTitle3)
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    Spacer()

                    VStack {
                        if email.isEmpty {
                            Image("signin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.7)
                                .shadow(radius: 5)
                        }
                        Text("Sign in to access all the features and track your mood journey.")
                            .font(.appCaption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.top, 2)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 10) {
                        TextFormField(placeholder: "Enter your email", textfieldContent: $email, keyboardType: .emailAddress)
                        TextFormField(placeholder: "Enter your password", textfieldContent: $password)
                    }
                    .padding(.bottom)

                    Spacer()

                    HStack {
                        Spacer()
                        Text("Forgot Password?")
                            .font(.appSubheadline)
                            .onTapGesture {
                                isShowingForgotPassword = true
                            }
                            .sheet(isPresented: $isShowingForgotPassword) {
                                ForgotPasswordView(isPresented: $isShowingForgotPassword)
                                    .presentationDetents([.medium])
                            }
                    }
                    .padding(.trailing)
                    .padding(.trailing)

                    LargeButton(title: "Login") {
                        Task {
                            await login()
                        }
                    }
                    .disabled(authVM.isLoading)
                    .padding(.horizontal)

                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.primary)
                        Button("Sign Up") {
                            isShowingSignup = true
                        }
                        .sheet(isPresented: $isShowingSignup) {
                            SignUpView(isPresented: $isShowingSignup)
                                .withErrorHandling()

                        }
                    }
                    .font(.appSubheadline)
                    .foregroundColor(.accentColor)
                    .padding()
                }
                .onReceive(authVM.$appError) { error in
                    if let localizedError = error {
                        errorHandling.handle(error: localizedError)
                    }
                }
            }
            if authVM.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }

        }.onChange(of: authVM.isUserLoggedIn) { status in
            if status {
                NavigationController.rootView(UIHostingController(rootView: TabbedView().withErrorHandling()))
            }
        }
    }

    func login() async {
        do {
            try await authVM.login(email: email.lowercased(), password: password)
        } catch {
            debugPrint("From the login screen \(error)")
        }
    }

}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
