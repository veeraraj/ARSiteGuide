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
        let plane = SCNPlane(
            width: CGFloat(objectAnchor.referenceObject.extent.x * 2),
            height: CGFloat(objectAnchor.referenceObject.extent.y * 2)
        )

        plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.0)

        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 15

        guard let retroTVScene = SCNScene(named: "3DAssets.scnassets/retroTV.scn"),
              let retroTVNode = retroTVScene.rootNode.childNodes.first else {
            return nil
        }

        retroTVNode.position = SCNVector3Zero
        planeNode.addChildNode(retroTVNode)
        node.addChildNode(planeNode)

        return node
    }
}

// MARK: Private setup methods
private extension ARViewController {
    func setup() {
        view.addSubview(sceneView)

        sceneView.easy.layout(Edges())
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
