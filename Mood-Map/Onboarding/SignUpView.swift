//
//  SignUpView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 13/06/23.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject private var authVM = AuthViewModel.shared

    var body: some View {
        VStack {
            Text("SignUp to Mood Map")
                .font(.appTitle3)
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack {
                if email.isEmpty {
                    Image("signup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        .shadow(radius: 5)
                }
                Text("Discover insights, track your emotions, and find balance in your mood journey.")
                    .font(.appCaption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 2)
            }

            VStack(alignment: .center) {
                TextFormField(placeholder: "Name", textfieldContent: $name, keyboardType: .default)
                TextFormField(placeholder: "Enter your email", textfieldContent: $email, keyboardType: .emailAddress)
                TextFormField(placeholder: "Enter your password", textfieldContent: $password, keyboardType: .default)
            }

            Spacer()

            LargeButton(title: "Sign Up") {
                Task {
                    await signup()
                }
            }
        }
        .onReceive(authVM.$appError) { error in
            if let localizedError = error {
                errorHandling.handle(error: localizedError)
            }
        }
        .navigationTitle("SignUp to Mood Map")
        .padding()
    }

    func signup() async {
        // Perform signup logic here
        // You can access the username and password variables to create a new user
        // Close the signup view after successful signup
        do {
            await authVM.signUp(name: name, email: email.lowercased(), password: password)
            if authVM.isUserLoggedIn {
                isPresented = false
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isPresented: .constant(false))
    }
}
