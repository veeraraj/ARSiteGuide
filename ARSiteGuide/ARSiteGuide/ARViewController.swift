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

    // MARK: Properties
    private lazy var trackingConfiguration: ARWorldTrackingConfiguration = makeTrackingConfiguration()

    private var infoPopupPlaneNode: SCNNode?

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
        guard let infoPopupPlaneNode else { return }

        infoPopupPlaneNode.eulerAngles.y = frame.camera.eulerAngles.y
    }
}

// MARK: Private setup methods
private extension ARViewController {
    func setup() {
        view.addSubview(sceneView)

        sceneView.easy.layout(Edges())
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

    func getInfoPopupNode(for anchor: ARObjectAnchor) -> SCNNode {
        let infoPopupPlane = getInfoPopupPlane()
        let infoPopupPlaneNode = SCNNode(geometry: infoPopupPlane)
        let node = SCNNode()

        infoPopupPlaneNode.position = SCNVector3Make(
            anchor.referenceObject.center.x,
            anchor.referenceObject.center.y + 0.12,
            anchor.referenceObject.center.z
        )
        infoPopupPlaneNode.eulerAngles.y = sceneView.session.currentFrame?.camera.eulerAngles.z ?? 0
        self.infoPopupPlaneNode = infoPopupPlaneNode
        node.addChildNode(infoPopupPlaneNode)

        return node
    }

    func getInfoPopupPlane() -> SCNPlane {
        let infoPopupPlane = SCNPlane(
            width: 0.2,
            height: 0.1
        )
        let infoPopupScene = SKScene(fileNamed: "InfoPopup")

        infoPopupPlane.cornerRadius = infoPopupPlane.width / 10
        infoPopupPlane.firstMaterial?.diffuse.contents = infoPopupScene
        infoPopupPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(
            SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0
        )
        infoPopupPlane.firstMaterial?.isDoubleSided = true

        return infoPopupPlane
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

    func makeTrackingConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()

        guard let arReferenceObjects = ARReferenceObject.referenceObjects(
            inGroupNamed: "PipeObjects",
            bundle: Bundle.main
        ) else {
            fatalError("failed to create AR reference objects")
        }

        configuration.detectionObjects = arReferenceObjects

        return configuration
    }
}
