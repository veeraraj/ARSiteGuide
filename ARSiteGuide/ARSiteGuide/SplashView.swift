//
//  SplashView.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import SwiftUI

struct SplashView: View {

    @State var isSplashDone: Bool = false

    var body: some View {
        VStack {
            if isSplashDone {
                LoginView()
            } else {
                Image("WKLogo")
                    .resizable()
                    .frame(maxWidth: 300, maxHeight: 300, alignment: .center)

                Text("Virtual Site Guide")
                    .font(.largeTitle)
                    .foregroundStyle(RadialGradient(
                        colors: [.red, .green, .blue],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100))
                    .padding(.top, 96)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isSplashDone = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
