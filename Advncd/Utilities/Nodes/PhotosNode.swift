//
//  PhotosNode.swift
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
    
    func PhotosNode(uuid: String, selectedType: String) -> SCNNode {
         DispatchQueue.main.async {
            let topLeftImage = UIImageView()
            let topLeftURL = Database.database().reference().child("Images").child("\(uuid)_TopLeft")
            topLeftURL.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                topLeftImage.contentMode = .scaleAspectFit
                topLeftImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let topLeftPlane = SCNPlane(width: 0.2, height: 0.15)
                    topLeftPlane.firstMaterial?.diffuse.contents = topLeftImage.image
                    topLeftPlane.cornerRadius = 0.0075
                    let topLeftPlaneNode = SCNNode(geometry: topLeftPlane)
                    topLeftPlaneNode.eulerAngles.x = -.pi / 2
                    self.addChildNode(topLeftPlaneNode)
                    topLeftPlaneNode.opacity = 0
                    topLeftPlaneNode.position = SCNVector3(0, 0.01, 0)
                    topLeftPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.15), SCNAction.fadeOpacity(by: 1, duration: 0.5), SCNAction.move(to: SCNVector3(x: -0.12, y: 0.01, z: -0.085), duration: 0.5)]))
                })
            })
            
            let topRightImage = UIImageView()
            let topRightURL = Database.database().reference().child("Images").child("\(uuid)_TopRight")
            topRightURL.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                topRightImage.contentMode = .scaleAspectFit
                topRightImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let topRightPlane = SCNPlane(width: 0.2, height: 0.15)
                    topRightPlane.firstMaterial?.diffuse.contents = topRightImage.image
                    topRightPlane.cornerRadius = 0.0075
                    let topRightPlaneNode = SCNNode(geometry: topRightPlane)
                    topRightPlaneNode.eulerAngles.x = -.pi / 2
                    self.addChildNode(topRightPlaneNode)
                    topRightPlaneNode.opacity = 0
                    topRightPlaneNode.position = SCNVector3(0, 0.01, 0)
                    topRightPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.15), SCNAction.fadeOpacity(by: 1, duration: 0.5), SCNAction.move(to: SCNVector3(x: 0.12, y: 0.015, z: -0.085), duration: 0.5)]))
                })
            })
            
            let bottomLeftImage = UIImageView()
            let bottomLeftURL = Database.database().reference().child("Images").child("\(uuid)_BottomLeft")
            bottomLeftURL.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                bottomLeftImage.contentMode = .scaleAspectFit
                bottomLeftImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let bottomLeftPlane = SCNPlane(width: 0.2, height: 0.15)
                    bottomLeftPlane.firstMaterial?.diffuse.contents = bottomLeftImage.image
                    bottomLeftPlane.cornerRadius = 0.0075
                    let bottomLeftPlaneNode = SCNNode(geometry: bottomLeftPlane)
                    bottomLeftPlaneNode.eulerAngles.x = -.pi / 2
                    self.addChildNode(bottomLeftPlaneNode)
                    bottomLeftPlaneNode.opacity = 0
                    bottomLeftPlaneNode.position = SCNVector3(0, 0.01, 0)
                    bottomLeftPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.15), SCNAction.fadeOpacity(by: 1, duration: 0.5), SCNAction.move(to: SCNVector3(x: -0.12, y: 0.02, z: 0.085), duration: 0.5)]))
                })
            })
            
            let bottomRightImage = UIImageView()
            let bottomRightURL = Database.database().reference().child("Images").child("\(uuid)_BottomRight")
            bottomRightURL.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                bottomRightImage.contentMode = .scaleAspectFit
                bottomRightImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let bottomRightPlane = SCNPlane(width: 0.2, height: 0.15)
                    bottomRightPlane.firstMaterial?.diffuse.contents = bottomRightImage.image
                    bottomRightPlane.cornerRadius = 0.0075
                    let bottomRightPlaneNode = SCNNode(geometry: bottomRightPlane)
                    bottomRightPlaneNode.eulerAngles.x = -.pi / 2
                    self.addChildNode(bottomRightPlaneNode)
                    bottomRightPlaneNode.opacity = 0
                    bottomRightPlaneNode.position = SCNVector3(0, 0.01, 0)
                    bottomRightPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.15), SCNAction.fadeOpacity(by: 1, duration: 0.5), SCNAction.move(to: SCNVector3(x: 0.12, y: 0.025, z: 0.085), duration: 0.5)]))
                })
            })
            
        }
        
        return self
    }
    
}
