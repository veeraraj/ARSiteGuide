//
//  LoginView.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import SwiftUI

struct LoginView: View {

    @State var name: String = ""
    @State var password: String = ""

    var shouldDisableSignIn: Bool {
        [name, password].contains(where: \.isEmpty)
    }

    var body: some View {
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

            Button {
                print("do login action")
            } label: {
                Text("Sign In")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
