//
//  HomeView.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import SwiftUI

struct HomeView: View {
    var user: User? = .user1

    var body: some View {
        NavigationView {
            VStack {
                List(user?.taskList ?? [], id: \.self) { task in
                    NavigationLink(
                        destination: WrapperView()
                            .ignoresSafeArea()
                    ) {
                        Text(task)
                            .padding()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: User.user1)
    }
}
