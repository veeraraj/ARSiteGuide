//
//  SplashView.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
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
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
