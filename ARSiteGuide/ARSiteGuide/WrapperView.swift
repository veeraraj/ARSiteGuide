//
//  WrapperView.swift
//  ARSiteGuide
//
//  Created by Zahari Georgiev on 09/05/2023.
//

import SwiftUI

struct WrapperView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode

    let instruction: Instruction

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    func makeUIViewController(context: Context) -> some UIViewController {
        return ARViewController(dismiss: {
            presentationMode.wrappedValue.dismiss()
        }, instruction: instruction)
    }
}
