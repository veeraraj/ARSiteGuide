//
//  HomeView.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import SwiftUI

struct HomeView: View {
    var user: User? = .user1

    @State var colors: [Color] = [.red, .green, .yellow, .pink, .blue, .orange, .cyan, .brown, .indigo, .mint, .teal, .purple]

    var body: some View {
        NavigationView {
            VStack {
                List(user?.taskList ?? [], id: \.self) { task in
                    NavigationLink(
                        destination: WrapperView()
                            .ignoresSafeArea()
                    ) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(colors.randomElement()!)
                                    .frame(width: 32,
                                           height: 32)
                                Circle()
                                    .fill(.white)
                                    .frame(width: 16,
                                           height: 16)
                            }
                            Text(task.id)
                            Spacer()
                            Image(systemName: "arrow.right.circle")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(8.0)
                        .shadow(radius: 5)
                    }
                    .padding(.trailing, -28.0)
                    .padding(.leading, -10.0)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: User.user1)
    }
}
