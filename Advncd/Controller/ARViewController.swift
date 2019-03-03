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
                print(QRServices.instance.allARImageReferenceImage.count)
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
        }
        return nil
    }
    
    
}

extension SCNNode {
    func RegularARNode(uuid: String, selectedType: String) -> SCNNode {
        let backgroundPlane = SCNPlane(width: 0.175, height: 0.25)
        backgroundPlane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.9)
        backgroundPlane.cornerRadius = 0.01
        let backgroundPlaneNode = SCNNode(geometry: backgroundPlane)
        backgroundPlaneNode.eulerAngles.x = -.pi / 2
        self.addChildNode(backgroundPlaneNode)
        backgroundPlaneNode.scale = SCNVector3(0, 0, 0)
        backgroundPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.15), SCNAction.scale(to: 1, duration: 0.5)]))
        
        let mainPlane = SCNPlane(width: 0.165, height: 0.24)
        mainPlane.firstMaterial?.diffuse.contents = UIColor.FlatColor.Blue.DarkBlue
        mainPlane.cornerRadius = 0.01
        let planeNode = SCNNode(geometry: mainPlane)
        planeNode.position = SCNVector3(backgroundPlaneNode.position.x, backgroundPlaneNode.position.y, 0.001)
        
        backgroundPlaneNode.addChildNode(planeNode)
        
        DispatchQueue.main.async {
            let mainImage = UIImageView()
            let mainImageStorageRef = Storage.storage().reference().child(selectedType).child("\(uuid)_Main.jpg")
            mainImage.sd_setImage(with: mainImageStorageRef, placeholderImage: #imageLiteral(resourceName: "Logo"))
            
            let mainImagePlane = SCNPlane(width: mainPlane.width - 0.02, height: mainPlane.height / 2)
            mainImagePlane.firstMaterial?.diffuse.contents = mainImage.image
            mainImagePlane.cornerRadius = 0.0075
            let mainImageNode = SCNNode(geometry: mainImagePlane)
            mainImageNode.position = SCNVector3(planeNode.position.x, 0.045, 0.01)
            
            mainImageNode.opacity = 0
            mainImageNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 1), SCNAction.fadeOpacity(by: 1, duration: 0.5)]))
            planeNode.addChildNode(mainImageNode)
        }
        
        //label
        let textScene = SKScene(size: CGSize(width: 600, height: 420))
        let reference = Firestore.firestore().collection("Texts").document("\(uuid)_Main")
        var standardText = ""
        reference.getDocument { (document, error) in
            if let document = document, document.exists {
                standardText = document.data()!["text"] as! String
                let str = SKLabelNode(text: standardText)
                textScene.backgroundColor = UIColor.clear
                str.fontColor = UIColor.white
                str.yScale = -1
                str.fontSize = 35
                str.fontName = "Montserrat-Regular"
                str.numberOfLines = 6
                str.preferredMaxLayoutWidth = 600
                str.horizontalAlignmentMode = .left
                str.position = CGPoint(x: textScene.anchorPoint.x + 0.01, y: 2 * (textScene.size.height/3))
                
                textScene.addChild(str)
                
                let textPlane = SCNPlane(width: mainPlane.width - 0.02, height: (mainPlane.height / 2) - 0.025)
                textPlane.firstMaterial?.diffuse.contents = textScene
                let textPlaneNode = SCNNode(geometry: textPlane)
                textPlaneNode.position = SCNVector3(planeNode.position.x, -0.0625, 0.01)
                planeNode.addChildNode(textPlaneNode)
            }
        }
        
        return self
    }
}
