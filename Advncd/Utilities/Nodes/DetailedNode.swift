//
//  DetailedNode.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/4.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import Firebase
import FirebaseUI
import FirebaseDatabase

extension SCNNode {

    func DetailedNodeAR(uuid: String, selectedType: String) -> SCNNode {
        let backgroundPlane = SCNPlane(width: 0.21, height: 0.3)
        backgroundPlane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.9)
        backgroundPlane.cornerRadius = 0.01
        let backgroundPlaneNode = SCNNode(geometry: backgroundPlane)
        backgroundPlaneNode.eulerAngles.x = -.pi / 2
        self.addChildNode(backgroundPlaneNode)
        backgroundPlaneNode.scale = SCNVector3(0, 0, 0)
        backgroundPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.15), SCNAction.scale(to: 1, duration: 0.5)]))
        
        let mainPlane = SCNPlane(width: 0.2, height: 0.29)
        let backgroundImage = #imageLiteral(resourceName: "AR-Background")
        mainPlane.firstMaterial?.diffuse.contents = backgroundImage
        mainPlane.cornerRadius = 0.01
        let planeNode = SCNNode(geometry: mainPlane)
        planeNode.position = SCNVector3(backgroundPlaneNode.position.x, backgroundPlaneNode.position.y, 0.001)
        
        backgroundPlaneNode.addChildNode(planeNode)
        
        DispatchQueue.main.async {
            let mainImage = UIImageView()
            let URLRef = Database.database().reference().child("Images").child("\(uuid)_Main")
            URLRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                mainImage.contentMode = .scaleAspectFit
                mainImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let mainImagePlane = SCNPlane(width: mainPlane.width - 0.03, height: mainPlane.height * 0.5)
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = mainImage.image
                    material.diffuse.contentsTransform = SCNMatrix4MakeScale(1, 0.7, 1)
                    material.diffuse.wrapS = SCNWrapMode.repeat
                    material.diffuse.wrapT = SCNWrapMode.repeat
                    mainImagePlane.firstMaterial = material
                    mainImagePlane.cornerRadius = 0.0075
                    let mainImageNode = SCNNode(geometry: mainImagePlane)
                    mainImageNode.position = SCNVector3(planeNode.position.x, 0.0625, 0.02)
                    
                    mainImageNode.opacity = 0
                    mainImageNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 1), SCNAction.fadeOpacity(by: 0.8, duration: 0.5)]))
                    planeNode.addChildNode(mainImageNode)
                })
            })
            
            let TopPannel = UIImageView()
            let TopPannelURLRef = Database.database().reference().child("Images").child("\(uuid)_PannelTop")
            TopPannelURLRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                TopPannel.contentMode = .scaleAspectFit
                TopPannel.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let TopPannelPlane = SCNPlane(width: mainPlane.width - 0.05, height: mainPlane.height * 0.4)
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = TopPannel.image
                    material.diffuse.contentsTransform = SCNMatrix4MakeScale(1, 0.7, 1)
                    material.diffuse.wrapS = SCNWrapMode.repeat
                    material.diffuse.wrapT = SCNWrapMode.repeat
                    TopPannelPlane.firstMaterial = material
                    TopPannelPlane.cornerRadius = 0.0075
                    let TopPannelNode = SCNNode(geometry: TopPannelPlane)
                    TopPannelNode.position = SCNVector3(planeNode.position.x, 0.07, 0.04)
                    TopPannelNode.opacity = 0
                    TopPannelNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 1), SCNAction.fadeOpacity(by: 1, duration: 0.1), SCNAction.move(to: SCNVector3(x: planeNode.position.x + 0.19, y: 0.07, z: 0.04), duration: 0.25)]))
                    backgroundPlaneNode.addChildNode(TopPannelNode)
                })
            })
            
            let BottomPannel = UIImageView()
            let BottomPannelURLRef = Database.database().reference().child("Images").child("\(uuid)_PannelBottom")
            BottomPannelURLRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                BottomPannel.contentMode = .scaleAspectFit
                BottomPannel.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let BottomPannelPlane = SCNPlane(width: mainPlane.width - 0.05, height: mainPlane.height * 0.4)
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = BottomPannel.image
                    material.diffuse.contentsTransform = SCNMatrix4MakeScale(1, 0.7, 1)
                    material.diffuse.wrapS = SCNWrapMode.repeat
                    material.diffuse.wrapT = SCNWrapMode.repeat
                    BottomPannelPlane.firstMaterial = material
                    BottomPannelPlane.cornerRadius = 0.0075
                    let BottomPannelNode = SCNNode(geometry: BottomPannelPlane)
                    BottomPannelNode.position = SCNVector3(planeNode.position.x, -0.07, 0.04)
                    BottomPannelNode.opacity = 0
                    BottomPannelNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 1), SCNAction.fadeOpacity(by: 1, duration: 0.1), SCNAction.move(to: SCNVector3(x: planeNode.position.x + 0.19, y: -0.07, z: 0.04), duration: 0.25)]))
                    backgroundPlaneNode.addChildNode(BottomPannelNode)
                })
            })
        }
        
        //label
        let reference = Firestore.firestore().collection("Texts").document("\(uuid)_Main")
        var standardText = ""
        reference.getDocument { (document, error) in
            if let document = document, document.exists {
                standardText = document.data()!["text"] as! String
                let textScene = SKScene(size: CGSize(width: 600, height: 450))
                
                let str = SKLabelNode(text: standardText)
                textScene.backgroundColor = UIColor.clear
                str.fontColor = UIColor.white
                str.yScale = -1
                str.fontSize = 30
                str.numberOfLines = 0
                str.fontName = "Montserrat-Regular"
                str.position = CGPoint(x:300,y:225)
                str.preferredMaxLayoutWidth = 600
                str.horizontalAlignmentMode = .center
                str.verticalAlignmentMode = .center
                
                textScene.addChild(str)
                
                let textPlane = SCNPlane(width: mainPlane.width - 0.02, height: mainPlane.height * 0.35)
                textPlane.firstMaterial?.diffuse.contents = textScene
                let textPlaneNode = SCNNode(geometry: textPlane)
                textPlaneNode.position = SCNVector3(planeNode.position.x, -0.065, 0.02)
                textPlaneNode.opacity = 0
                textPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 1), SCNAction.fadeOpacity(by: 1, duration: 0.5)]))
                planeNode.addChildNode(textPlaneNode)
            }
        }
        
        return self
    }
    
}
