//
//  User.swift
//  ARSiteGuide
//
//  Created by Veeraraj on 09/05/2023.
//

import Foundation


enum User: String, CaseIterable {
    case user1
    case user2

    var taskList: [String] {
        switch self {
        case .user1:
            return ["Tank", "Pipe", "Switch"]
        case .user2:
            return ["Rotate", "Arch", "Stop"]
        }
    }
}
