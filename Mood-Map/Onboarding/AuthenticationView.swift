//
//  AuthenticationView.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 08/06/23.
//

import SwiftUI
import MoodMapKit

struct AuthenticationView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    @State private var username: String = "albert@gmail.com"
    @State private var password: String = "h9ugE*D%u#JXbE$E"
    @State private var isShowingSignup: Bool = false
    @State private var isShowingForgotPassword: Bool = false
    @ObservedObject private var authVM = AuthViewModel.shared

    var body: some View {
        ZStack {
            VStack {
                //            Image("logo") // Replace with your app logo

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Login") {
                    // Perform login logic here
                    login()
                }
                .padding()

                Button("Signup") {
                    isShowingSignup = true
                }
                .padding()
                .sheet(isPresented: $isShowingSignup) {
                    SignupView(isPresented: $isShowingSignup)
                }

                Button("Forgot Password") {
                    isShowingForgotPassword = true
                }
                .padding()
                .sheet(isPresented: $isShowingForgotPassword) {
                    ForgotPasswordView(isPresented: $isShowingForgotPassword)
                }

                Spacer()
            }.onReceive(authVM.$appError) { error in
                if let localizedError = error {

                    errorHandling.handle(error: localizedError)

                }
            }

            .padding()

        }
    }

    func login() {
        // Perform login logic here
        // You can access the username and password variables to authenticate the user
        do {
            try authVM.login(email: username.lowercased(), password: password)

        } catch {
            debugPrint("From the login screen \(error)")
        }
    }
}

struct SignupView: View {
    @Binding var isPresented: Bool
    @State private var username: String = "albert@gmail.com"
    @State private var password: String = "h9ugE*D%u#JXbE$E"
    @ObservedObject private var authVM = AuthViewModel()

    var body: some View {
        VStack {
            Text("Signup")
                .font(.largeTitle)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Signup") {
                // Perform signup logic here
                signup()
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    func signup() {
        // Perform signup logic here
        // You can access the username and password variables to create a new user
        isPresented = false // Close the signup view after successful signup
        authVM.signUp(email: username.lowercased(), password: password)
    }
}

struct ForgotPasswordView: View {
    @Binding var isPresented: Bool
    @State private var password: String = "aNXdy2EA!ZNzHnQL"
    @ObservedObject private var authVM = AuthViewModel.shared

    var body: some View {
        VStack {
            Text("Forgot Password")
                .font(.largeTitle)

            TextField("Email", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Reset Password") {
                // Perform forgot password logic here
                resetPassword()
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    func resetPassword() {
        // Perform forgot password logic here
        // You can access the email variable to send a password reset email
        authVM.resetPassword(password: password)
        isPresented = false // Close the forgot password view after requesting password reset
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
