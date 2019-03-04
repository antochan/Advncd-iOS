//
//  ARViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import ARKit
import Firebase
import SDWebImage
import FirebaseUI

class ARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var ARTrackingImages = Set<ARReferenceImage>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        QRServices.instance.getAllQRCodes { (success) in
            if success {
                self.loadingLabel.isHidden = true
                let configuration = ARImageTrackingConfiguration()
                configuration.trackingImages = QRServices.instance.allARImageReferenceImage
                configuration.maximumNumberOfTrackedImages = 1
                self.sceneView.session.run(configuration)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        let scene = SCNScene()
        sceneView.delegate = self
        sceneView.scene = scene
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getQRData() {
        QRServices.instance.getAllQRCodes { (success) in
            if success {
                self.loadingLabel.removeFromSuperview()
            }
        }
    }
    
    func getStandardText(qrId: String) -> String {
        let reference = Firestore.firestore().collection("Texts").document("\(qrId)_Main")
        var standardText = ""
        reference.getDocument { (document, error) in
            if let document = document, document.exists {
                standardText = document.data()!["text"] as! String
            }
        }
        return standardText
    }

}

extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        if let unfilteredName = imageAnchor.name {
            let filteredNameArray = unfilteredName.components(separatedBy: "_")
            let qrId = filteredNameArray[0]
            let selectedType = filteredNameArray[1]
            
            if selectedType == "Standard" {
                return node.RegularARNode(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Detailed" {
                return node.DetailedNodeAR(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Resume" {
                return node.ResumeNode(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Photos" {
                return node.PhotosNode(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Gallery" {
                return node.GalleryNode(uuid: qrId, selectedType: selectedType)
            }
        }
        return nil
    }
    
    
}
