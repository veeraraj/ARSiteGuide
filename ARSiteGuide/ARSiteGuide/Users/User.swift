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

    var instructionList: [Instruction] {
        switch self {
        case .user1:
            return [
                Instruction(id: "Task 1", tasks: [
                    Task(
                        equipment: .blueTank,
                        instructions: "Fill this up with gas"
                    ),
                    Task(
                        equipment: .redPipe,
                        instructions: "Close the valve"
                    )
                ]),
                Instruction(id: "Task 2", tasks: [
                    Task(
                        equipment: .redPipe,
                        instructions: "Close the valve"
                    )
                ]),
                Instruction(id: "Task 3", tasks: [
                    Task(
                        equipment: .blueTank,
                        instructions: "Fill this up with gas"
                    )
                ])
            ]
        case .user2:
            return [
                Instruction(id: "Task 1", tasks: [
                    Task(
                        equipment: .blueTank,
                        instructions: "Fill this up with gas"
                    ),
                    Task(
                        equipment: .redPipe,
                        instructions: "Close the valve"
                    )
                ]),
                Instruction(id: "Task 2", tasks: [
                    Task(
                        equipment: .redPipe,
                        instructions: "Close the valve"
                    )
                ]),
                Instruction(id: "Task 3", tasks: [
                    Task(
                        equipment: .blueTank,
                        instructions: "Fill this up with gas"
                    )
                ]),
                Instruction(id: "Task 4", tasks: [
                    Task(
                        equipment: .redPipe,
                        instructions: "Close the valve"
                    )
                ]),
                Instruction(id: "Task 5", tasks: [
                    Task(
                        equipment: .blueTank,
                        instructions: "Fill this up with gas"
                    )
                ])
            ]
        }
    }
}

struct Instruction: Equatable, Hashable {
    let id: String
    let tasks: [Task]
}

struct Task: Equatable, Hashable {
    let equipment: Equipment
    let instructions: String
}
