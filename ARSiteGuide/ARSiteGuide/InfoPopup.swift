//
//  InfoPopup.swift
//  ARSiteGuide
//
//  Created by Zahari Georgiev on 10/05/2023.
//

import Foundation
import SpriteKit


class InfoPopup: SKScene {

    lazy var nameLabel: SKLabelNode = makeNameLabel()
    lazy var instructionsLabel: SKLabelNode = makeInstructionsLabel()
    lazy var imageView: SKSpriteNode = makeImageView()

    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
}

// MARK: Update methods
extension InfoPopup {
    func update(with viewModel: ViewModel) {
        updateImage(to: viewModel.imageName)
        updateLabel(nameLabel, with: viewModel.name)
        updateLabel(instructionsLabel, with: viewModel.instructions)
    }
}

// MARK: Factory methods
private extension InfoPopup {
    func makeNameLabel() -> SKLabelNode {
        let label = childNode(withName: "nameLabel") as! SKLabelNode
        label.horizontalAlignmentMode = .left
        return label
    }

    func makeInstructionsLabel() -> SKLabelNode {
        let label = childNode(withName: "instructionsLabel") as! SKLabelNode
        label.horizontalAlignmentMode = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.preferredMaxLayoutWidth = 220
        label.verticalAlignmentMode = .top
        return label
    }

    func makeImageView() -> SKSpriteNode {
        let imageView = childNode(withName: "imageView") as! SKSpriteNode
        return imageView
    }
}

// MARK: ViewModel
extension InfoPopup {
    struct ViewModel {
        let name: String
        let instructions: String
        let imageName: String
    }
}


// MARK: Private helper methods
private extension InfoPopup {
    func updateImage(to imageName: String) {
        let oldPosition = imageView.position
        imageView.texture = SKTexture(imageNamed: imageName)
        imageView.size = CGSize(width: 130, height: 110)
        imageView.position = oldPosition
    }

    func updateLabel(_ label: SKLabelNode, with text: String) {
        label.text = text

        if label == instructionsLabel {
            label.position.y = 30
        }

        alignLabelToImageView(label)
    }

    func alignLabelToImageView(_ label: SKLabelNode) {
        label.position.x = imageView.position.x + (imageView.size.width / 2) + 20
    }
}
