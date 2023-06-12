//
//  ForgotPasswordView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 13/06/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    @Binding var isPresented: Bool
    @State private var password: String = "aNXdy2EA!ZNzHnQL"
    @ObservedObject private var authVM = AuthViewModel.shared

    var body: some View {
        VStack {
            TextFormField(placeholder: "Enter your password", textfieldContent: $password)

            LargeButton(title: "Update Password") {
                resetPassword()

                //                NavigationController.rootView(UIHostingController(rootView: HomeView()))
            }.padding(.top)
            Spacer()
        }.onReceive(authVM.$appError) { error in
            if let localizedError = error {

                errorHandling.handle(error: localizedError)

            }
        }
        .navigationTitle("Forgot Password")
        .padding()
    }

    func resetPassword() {
        // Perform forgot password logic here
        // You can access the email variable to send a password reset email
        authVM.resetPassword(password: password)
        isPresented = false // Close the forgot password view after requesting password reset
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(isPresented: .constant(false))
    }
}
