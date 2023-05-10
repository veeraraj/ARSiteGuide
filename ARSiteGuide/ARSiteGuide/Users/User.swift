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

    var taskList: [Task] {
        switch self {
        case .user1:
            return [
                Task(
                    id: "Task 1",
                    equipment: .blueTank,
                    instructions: "Fill this up with gas"
                ),
                Task(
                    id: "Task 2",
                    equipment: .redPipe,
                    instructions: "Use these pipes to control the flow of water coming from the tank"
                )
            ]
        case .user2:
            return [
                Task(
                    id: "Task 1",
                    equipment: .blueTank,
                    instructions: "Fill this up with gas"
                ),
                Task(
                    id: "Task 2",
                    equipment: .redPipe,
                    instructions: "Use these pipes to control the flow of water coming from the tank"
                ),
                Task(
                    id: "Task 3",
                    equipment: .blueTank,
                    instructions: "Fill this up with gas"
                ),
                Task(
                    id: "Task 4",
                    equipment: .redPipe,
                    instructions: "Use these pipes to control the flow of water coming from the tank"
                ),
                Task(
                    id: "Task 5",
                    equipment: .redPipe,
                    instructions: "Use these pipes to control the flow of water coming from the tank"
                )
            ]
        }
    }
}

struct Task: Equatable, Hashable {
    let id: String
    let equipment: Equipment
    let instructions: String
}
