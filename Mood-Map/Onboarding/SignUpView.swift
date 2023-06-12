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
    @State private var name: String = "Robert"
    @State private var email: String = "robert@gmail.com"
    @State private var password: String = "robert@gmail.com"
    @ObservedObject private var authVM = AuthViewModel.shared

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("C")
                        .font(.appHeadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding()

                Spacer()

                Image("signup")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width*0.7)
                    .shadow(radius: 5)
                Spacer()
                VStack(alignment: .center) {
                    TextFormField(placeholder: "Name", textfieldContent: $name)
                    TextFormField(placeholder: "Enter your email", textfieldContent: $email, keyboardType: .emailAddress)
                    TextFormField(placeholder: "Enter your password", textfieldContent: $password)
                }

                Spacer()

                LargeButton(title: "Sign Up") {
                    signup()
                    //                NavigationController.rootView(UIHostingController(rootView: HomeView()))
                }

            }.onReceive(authVM.$appError) { error in
                if let localizedError = error {

                    errorHandling.handle(error: localizedError)

                }
            }
            .navigationTitle("SignUp to Mood Map")
            .padding()
        }
    }

    func signup() {
        // Perform signup logic here
        // You can access the username and password variables to create a new user
        isPresented = false // Close the signup view after successful signup
        authVM.signUp(name: name, email: email.lowercased(), password: password)
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isPresented: .constant(false))
    }
}
