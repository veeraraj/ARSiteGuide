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
                        .frame(maxWidth: 200, maxHeight: 200)
                    Spacer()
                }
                .padding(.top, 96)
                .padding(.bottom, 48)

                TextField("Name",
                          text: $name ,
                          prompt: Text("User name").foregroundColor(.blue)
                )
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)

                SecureField("Password",
                            text: $password,
                            prompt: Text("Password").foregroundColor(.blue))
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)

                Spacer()

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
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
