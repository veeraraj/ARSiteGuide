//
//  WrapperView.swift
//  ARSiteGuide
//
//  Created by Zahari Georgiev on 09/05/2023.
//

import SwiftUI

struct WrapperView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    func makeUIViewController(context: Context) -> some UIViewController {
        return ARViewController(dismiss: {
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct WrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView()
            .ignoresSafeArea()
    }
}
