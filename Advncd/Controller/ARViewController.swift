//
//  ARViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var ARTrackingImages = Set<ARReferenceImage>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        QRServices.instance.getAllQRCodes { (success) in
            if success {
                print(QRServices.instance.allARImageReferenceImage.count)
                self.loadingLabel.removeFromSuperview()
                let configuration = ARImageTrackingConfiguration()
                configuration.trackingImages = QRServices.instance.allARImageReferenceImage
                configuration.maximumNumberOfTrackedImages = 1
                self.sceneView.session.run(configuration)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.delegate = self
        sceneView.scene = scene
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func getQRData() {
        QRServices.instance.getAllQRCodes { (success) in
            if success {
                print(QRServices.instance.allARImageReferenceImage.count)
                self.loadingLabel.removeFromSuperview()
            }
        }
    }

}

extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        print(imageAnchor.name)
        
        return node
    }
    
    
}
