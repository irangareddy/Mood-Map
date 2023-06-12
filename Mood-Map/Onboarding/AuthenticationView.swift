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
                    SignUpView(isPresented: $isShowingSignup)
                }

                Button("Forgot Password") {
                    isShowingForgotPassword = true
                }
                .padding()

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

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
