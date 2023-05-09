//
//  LoginViewModel.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    func userDetails(userName: String, password: String) -> (isValidUser: Bool, userDetails: User?) {
        let isValidUser = User.allCases.contains(where: { $0.rawValue == userName.lowercased() })
        let user = User(rawValue: userName.lowercased())
        return (isValidUser, user)
    }
}
