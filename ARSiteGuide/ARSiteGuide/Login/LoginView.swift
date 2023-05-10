//
//  LoginView.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var isValidUser: Bool = false
    @State private var showAlert = false
    @State private var user: User?

    var shouldDisableSignIn: Bool {
        [name, password].contains(where: \.isEmpty)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Spacer()
                    Image("WKLogo")
                        .resizable()
                        .frame(width: 200, height: 200)
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 16)

                Text("Login")
                    .font(Font.title.weight(.bold))
                    .padding(.leading, 16)

                HStack {
                    Image(systemName: "person")
                        .font(.system(size: 24, weight: .bold))

                    VStack {
                        TextField("Name",
                                  text: $name ,
                                  prompt: Text("User name").foregroundColor(.gray)
                        )
                        Divider()
                    }

                }
                .padding(.all, 16)

                HStack {
                    Image(systemName: "lock")
                        .font(.system(size: 24, weight: .bold))
                    VStack {
                        SecureField("Password",
                                    text: $password,
                                    prompt: Text("Password").foregroundColor(.gray))
                        Divider()
                    }
                }
                .padding(.all, 16)

                HStack {
                    Spacer()
                    Button(action: {}) {
                        Text("Forgot Password?")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("actionButton"))
                    }
                    .frame(alignment: .trailing)
                    .padding(.trailing, 16)
                }


                NavigationLink(destination: HomeView(user: user), isActive: $isValidUser) {
                    Button(action: {
                        let user = viewModel.userDetails(userName: name, password: password)
                        self.isValidUser = user != nil
                        self.showAlert = user == nil
                        self.user = user
                    }) {
                        Text("Sign In")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(
                                shouldDisableSignIn ?
                                RadialGradient(colors: [.gray], center: .center, startRadius: 0, endRadius: 100) :
                                    RadialGradient( colors: [.red, .green, .blue], center: .center, startRadius: 0, endRadius: 100)
                            )
                            .cornerRadius(20)
                            .disabled(shouldDisableSignIn)
                            .padding()
                    }
                }
                .alert("Invalid Username or Password", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }

                HStack {
                    VStack {
                        Divider()
                    }
                    Text("OR")
                        .foregroundColor(.gray)
                    VStack {
                        Divider()
                    }
                }
                .padding(.horizontal, 16)


                Button(action: {
                    // Login with okta
                }) {
                    Text("Sign In with SSO")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.gray)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color("okta"))
                        .cornerRadius(20)
                        .padding()
                }

                HStack {
                    Spacer()
                    Text("New User?")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .light))
                    Button(action: {}) {
                        Text("Register")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("actionButton"))
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)

                Spacer()

            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
