//
//  GalleryNode.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/5.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import Firebase
import FirebaseUI
import FirebaseDatabase

extension SCNNode {
    
    func GalleryNode(uuid: String, selectedType: String) -> SCNNode {
        let backgroundPlane = SCNPlane(width: 0.37, height: 0.28)
        backgroundPlane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.9)
        backgroundPlane.cornerRadius = 0.01
        let backgroundPlaneNode = SCNNode(geometry: backgroundPlane)
        backgroundPlaneNode.eulerAngles.x = -.pi / 2
        self.addChildNode(backgroundPlaneNode)
        backgroundPlaneNode.scale = SCNVector3(0, 0, 0)
        backgroundPlaneNode.position = SCNVector3(0,0,-0.05)
        backgroundPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.3), SCNAction.scale(to: 1, duration: 0.5)]))
        
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
                    let mainImagePlane = SCNPlane(width: 0.35, height: 0.265)
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = mainImage.image
                    material.diffuse.wrapS = SCNWrapMode.repeat
                    material.diffuse.wrapT = SCNWrapMode.repeat
                    mainImagePlane.firstMaterial = material
                    mainImagePlane.cornerRadius = 0.0075
                    let mainImageNode = SCNNode(geometry: mainImagePlane)
                    mainImageNode.position = SCNVector3(0,0,0.015)
                    mainImageNode.opacity = 0
                    mainImageNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5), SCNAction.fadeOpacity(by: 1, duration: 0.5)]))
                    backgroundPlaneNode.addChildNode(mainImageNode)
                })
            })
            
            let bottomLeftImage = UIImageView()
            let bottomLeftURLRef = Database.database().reference().child("Images").child("\(uuid)_BottomLeft")
            bottomLeftURLRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                bottomLeftImage.contentMode = .scaleAspectFit
                bottomLeftImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let bottomLeftPlane = SCNPlane(width: 0.133, height: 0.1)
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = bottomLeftImage.image
                    material.diffuse.wrapS = SCNWrapMode.repeat
                    material.diffuse.wrapT = SCNWrapMode.repeat
                    bottomLeftPlane.firstMaterial = material
                    bottomLeftPlane.cornerRadius = 0.0075
                    let bottomLeftNode = SCNNode(geometry: bottomLeftPlane)
                    bottomLeftNode.position = SCNVector3(-0.143,-0.2,0.015)
                    bottomLeftNode.opacity = 0
                    bottomLeftNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 1), SCNAction.fadeOpacity(by: 1, duration: 0.5)]))
                    backgroundPlaneNode.addChildNode(bottomLeftNode)
                })
            })
            
            let bottomMidImage = UIImageView()
            let bottomMidURLRef = Database.database().reference().child("Images").child("\(uuid)_BottomMid")
            bottomMidURLRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                bottomMidImage.contentMode = .scaleAspectFit
                bottomMidImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let bottomMidPlane = SCNPlane(width: 0.133, height: 0.1)
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = bottomMidImage.image
                    material.diffuse.wrapS = SCNWrapMode.repeat
                    material.diffuse.wrapT = SCNWrapMode.repeat
                    bottomMidPlane.firstMaterial = material
                    bottomMidPlane.cornerRadius = 0.0075
                    let bottomMidNode = SCNNode(geometry: bottomMidPlane)
                    bottomMidNode.position = SCNVector3(0,-0.2,0.015)
                    bottomMidNode.opacity = 0
                    bottomMidNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.2), SCNAction.fadeOpacity(by: 1, duration: 0.5)]))
                    backgroundPlaneNode.addChildNode(bottomMidNode)
                })
            })
            
            let bottomRightImage = UIImageView()
            let bottomRightURLRef = Database.database().reference().child("Images").child("\(uuid)_BottomRight")
            bottomRightURLRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                bottomRightImage.contentMode = .scaleAspectFit
                bottomRightImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let bottomRightPlane = SCNPlane(width: 0.133, height: 0.1)
                    
                    let material = SCNMaterial()
                    material.diffuse.contents = bottomRightImage.image
                    material.diffuse.wrapS = SCNWrapMode.repeat
                    material.diffuse.wrapT = SCNWrapMode.repeat
                    bottomRightPlane.firstMaterial = material
                    bottomRightPlane.cornerRadius = 0.0075
                    let bottomRightNode = SCNNode(geometry: bottomRightPlane)
                    bottomRightNode.position = SCNVector3(0.143,-0.2,0.015)
                    bottomRightNode.opacity = 0
                    bottomRightNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.4), SCNAction.fadeOpacity(by: 1, duration: 0.5)]))
                    backgroundPlaneNode.addChildNode(bottomRightNode)
                })
            })
            
        }
        return self
    }

}
