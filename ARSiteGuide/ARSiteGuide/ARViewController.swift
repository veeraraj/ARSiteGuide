//
//  ARViewController.swift
//  ARSiteGuide
//
//  Created by Zahari Georgiev on 09/05/2023.
//

import UIKit
import EasyPeasy
import ARKit

class ARViewController: UIViewController {

    // MARK: Views
    private lazy var sceneView: ARSCNView = makeSceneView()
    private lazy var submitButton: UIButton = makeSubmitButton()

    // MARK: Properties
    private lazy var trackingConfiguration: ARWorldTrackingConfiguration = makeTrackingConfiguration()

    private var infoPopupNodes: [SCNNode] = []

    private let dismiss: () -> Void

    init(dismiss: @escaping (() -> Void)) {
        self.dismiss = dismiss

        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sceneView.session.run(trackingConfiguration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }
}

// MARK: ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let objectAnchor = anchor as? ARObjectAnchor else { return nil }
        let node = SCNNode()

        if let objectPlaneNode = getObjectPlane(for: objectAnchor) {
            node.addChildNode(objectPlaneNode)
        }
        let infoPopupNode = getInfoPopupNode(for: objectAnchor)

        node.addChildNode(infoPopupNode)

        return node
    }
}

extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard !infoPopupNodes.isEmpty else { return }

        infoPopupNodes.forEach { infoPopupNode in
            infoPopupNode.eulerAngles.y = frame.camera.eulerAngles.y
        }
    }
}

// MARK: Private setup methods
private extension ARViewController {
    func setup() {
        view.addSubview(sceneView)
        view.addSubview(submitButton)

        sceneView.easy.layout(Edges())
        submitButton.easy.layout(
            Bottom(10).to(view.safeAreaLayoutGuide, .bottom),
            Left(20),
            Right(20),
            Height(50)
        )
    }
}

// MARK: Private helper methods
private extension ARViewController {
    func getObjectPlane(for anchor: ARObjectAnchor) -> SCNNode? {
        guard let objectNode = getObjectNode(for: anchor) else {
            print("failed to get node for anchor \(anchor.name ?? "unknown")")
            return nil
        }
        let plane = SCNPlane(
            width: CGFloat(anchor.referenceObject.extent.x * 2),
            height: CGFloat(anchor.referenceObject.extent.y * 2)
        )
        let planeNode = SCNNode(geometry: plane)

        plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.0)
        planeNode.eulerAngles.x = -.pi / 15
        planeNode.addChildNode(objectNode)

        return planeNode
    }

    func getObjectNode(for anchor: ARObjectAnchor) -> SCNNode? {
        guard let asset = getAsset(for: anchor),
              let scene = SCNScene(asset: asset) else {
            return nil
        }
        let node = scene.rootNode.childNodes.first
        node?.position = SCNVector3Zero

        return node
    }

    func getAsset(for anchor: ARObjectAnchor) -> Asset3D? {
        switch anchor.name {
        case "RedPipe":
            return .retroTV
        case "BlueTank":
            return .wheelBarrow
        default:
            return nil
        }
    }

    func getEquipment(for anchor: ARObjectAnchor) -> Equipment? {
        switch anchor.name {
        case "RedPipe":
            return .redPipe
        case "BlueTank":
            return .blueTank
        default:
            return nil
        }
    }

    func getInfoPopupNode(for anchor: ARObjectAnchor) -> SCNNode {
        let infoPopupPlane = getInfoPopupPlane(for: .blueTank)
        let infoPopupPlaneNode = SCNNode(geometry: infoPopupPlane)
        let node = SCNNode()

        infoPopupPlaneNode.position = SCNVector3Make(
            anchor.referenceObject.center.x,
            anchor.referenceObject.center.y + 0.12,
            anchor.referenceObject.center.z
        )
        infoPopupPlaneNode.eulerAngles.y = sceneView.session.currentFrame?.camera.eulerAngles.y ?? 0
        infoPopupNodes.append(infoPopupPlaneNode)
        node.addChildNode(infoPopupPlaneNode)

        return node
    }

    func getInfoPopupPlane(for equipment: Equipment) -> SCNPlane {
        let infoPopupPlane = SCNPlane(
            width: 0.2,
            height: 0.1
        )
        let infoPopupScene = InfoPopup(fileNamed: "InfoPopup")

        infoPopupScene?.update(with: getInfoViewModel(for: equipment))

        infoPopupPlane.cornerRadius = infoPopupPlane.width / 10
        infoPopupPlane.firstMaterial?.diffuse.contents = infoPopupScene
        infoPopupPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(
            SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0
        )
        infoPopupPlane.firstMaterial?.isDoubleSided = true

        return infoPopupPlane
    }

    func getInfoViewModel(for equipment: Equipment) -> InfoPopup.ViewModel {
        let name: String
        let instructions: String
        let imageName: String
        switch equipment {
        case .blueTank:
            name = "Blue tank"
            instructions = "Fill this up with gas"
            imageName = "blueTankPreview"
        case .redPipe:
            name = "Red pipe"
            instructions = "Use these pipes to control the flow of water from the tank going"
            imageName = "redPipePreview"
        }
        return .init(
            name: name,
            instructions: instructions,
            imageName: imageName
        )
    }
}

// MARK: Factory methods
private extension ARViewController {
    func makeSceneView() -> ARSCNView {
        let sceneView = ARSCNView()
        guard let scene = SCNScene(named: "3DAssets.scnassets/siteScene.scn") else {
            fatalError("failed to create site scene")
        }

        sceneView.delegate = self
        sceneView.scene = scene
        sceneView.session.delegate = self

        return sceneView
    }

    func makeSubmitButton() -> UIButton {
        var filled = UIButton.Configuration.filled()
        filled.title = "Mark as completed"
        filled.buttonSize = .large

        let button = UIButton(configuration: filled, primaryAction: nil)
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        return button
    }

    func makeTrackingConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()

        guard let arReferenceObjects = ARReferenceObject.referenceObjects(
            inGroupNamed: "PipeObjects",
            bundle: Bundle.main
        ) else {
          //  fatalError("failed to create AR reference objects")
            return configuration
        }
        configuration.detectionObjects = arReferenceObjects

        return configuration
    }
}

@objc private extension ARViewController {
    func didTapSubmit() {
        dismiss()
    }
}
