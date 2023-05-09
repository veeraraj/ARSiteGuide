//
//  HomeView.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink(destination: LoginView()) { Text(" Site 1").padding().background(Color.green)
                    }
                    NavigationLink(destination: LoginView()) { Text(" Site 2").padding().background(Color.green)
                    }
                    NavigationLink(destination: LoginView()) { Text(" Site 3").padding().background(Color.green)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
