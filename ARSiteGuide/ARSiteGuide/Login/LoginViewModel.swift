//
//  LoginViewModel.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    func userDetails(userName: String, password: String) -> User? {
        User(rawValue: userName.lowercased())
    }
}
