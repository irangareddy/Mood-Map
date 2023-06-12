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
    @State private var email: String = "robert@gmail.com"
    @State private var password: String = "robert@gmail.com"
    @State private var isShowingSignup: Bool = false
    @State private var isShowingForgotPassword: Bool = false
    @ObservedObject private var authVM = AuthViewModel.shared

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Text("Already have a Mood Map account?")
                        .font(.appHeadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding()
                Spacer()
                Image("signin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width*0.7)
                    .shadow(radius: 5)
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    TextFormField(placeholder: "Enter your email", textfieldContent: $email, keyboardType: .emailAddress)
                    TextFormField(placeholder: "Enter your password", textfieldContent: $password)
                }.padding(.bottom)

                Spacer()

                HStack {
                    Spacer()
                    Text("Forgot Password ?")
                        .font(.appSubheadline)
                        .onTapGesture {
                            isShowingForgotPassword = true
                        }
                        .sheet(isPresented: $isShowingForgotPassword) {
                            ForgotPasswordView(isPresented: $isShowingForgotPassword)
                        }
                }.padding(.trailing)
                .padding(.trailing)

                LargeButton(title: "Login") {
                    login()
                }.padding(.horizontal)

                Text("Don't have an account?")
                    .font(.appSubheadline)

                Button("Sign Up") {
                    isShowingSignup = true
                }
                .sheet(isPresented: $isShowingSignup) {
                    SignUpView(isPresented: $isShowingSignup)
                }

                .foregroundColor(.accentColor)
                .padding()

            }.onReceive(authVM.$appError) { error in
                if let localizedError = error {

                    errorHandling.handle(error: localizedError)

                }
            }
            .navigationTitle("SignIn to Mood Map")
        }
    }

    func login() {
        // Perform login logic here
        // You can access the username and password variables to authenticate the user
        do {
            try authVM.login(email: email.lowercased(), password: password)
            //            NavigationController.rootView(UIHostingController(rootView: TabbedView()))
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
