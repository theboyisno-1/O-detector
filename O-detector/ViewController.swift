//
//  ViewController.swift
//  O-detector
//
//  Created by Abdultawwab Khan on 14/06/19.
//  Copyright © 2019 Abdultawwab Khan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.font = label.font.withSize(14)
        label.textColor = UIColor.brown
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.addSubview(infoLabel)
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        guard let refObjects = ARReferenceObject.referenceObjects(inGroupNamed:"arobjects",bundle: nil) else {
            fatalError("Missing expected asset resources.")
        }
        
        configuration.detectionObjects = refObjects
        sceneView.debugOptions = [ARSCNDebugOptions.showWireframe,
                                  ARSCNDebugOptions.showBoundingBoxes,
                                  ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoLabel.frame = CGRect(x: 0, y: 16, width: sceneView.bounds.width, height: 36)
        infoLabel.text = "By KhanAbdul"
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("in 1st")
        if let objectAnchor = anchor as? ARObjectAnchor {
            print("Detected")
            let translation = objectAnchor.transform.columns.3
            let pos = float3(translation.x, translation.y, translation.z)
            let nodeArrow = self.getArrowNode()
            nodeArrow.position = SCNVector3(pos)
            sceneView.scene.rootNode.addChildNode(nodeArrow)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("failed")
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func getArrowNode() -> SCNNode {
        print("Getting yellow")
        let sceneURL = Bundle.main.url(forResource: "arrow_yellow", withExtension: "scn", subdirectory: "art.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        print("got yellow")
        return referenceNode
    }
}
