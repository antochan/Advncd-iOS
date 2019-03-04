//
//  ResumeNode.swift
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
    
    func ResumeNode(uuid: String, selectedType: String) -> SCNNode {
        DispatchQueue.main.async {
            let resumeImage = UIImageView()
            let URLRef = Database.database().reference().child("Images").child("\(uuid)_Resume")
            URLRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                resumeImage.contentMode = .scaleAspectFit
                resumeImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let resumePlane = SCNPlane(width: 0.21, height: 0.3)
                    resumePlane.firstMaterial?.diffuse.contents = resumeImage.image
                    let resumePlaneNode = SCNNode(geometry: resumePlane)
                    resumePlaneNode.eulerAngles.x = -.pi / 2
                    self.addChildNode(resumePlaneNode)
                    resumePlaneNode.position = SCNVector3(0.17, 0.01, 0.21)
                    resumePlaneNode.scale = SCNVector3(0, 0, 0)
                    resumePlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.15), SCNAction.scale(to: 1, duration: 0.5)]))
                })
            })
            
            let headShotImage = UIImageView()
            let headShotImageRef = Database.database().reference().child("Images").child("\(uuid)_Headshot")
            headShotImageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let urlString = snapshot.value as! String
                let url = URL(string: urlString)
                headShotImage.contentMode = .scaleAspectFit
                headShotImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Logo"), completed: { image, error, cacheType, imageURL in
                    // your rest code
                    let headShotPlane = SCNPlane(width: 0.07, height: 0.07)
                    headShotPlane.cornerRadius = 0.035
                    headShotPlane.firstMaterial?.diffuse.contents = headShotImage.image
                    let headShotPlaneNode = SCNNode(geometry: headShotPlane)
                    headShotPlaneNode.eulerAngles.x = -.pi / 2
                    self.addChildNode(headShotPlaneNode)
                    headShotPlaneNode.position = SCNVector3(0.05, 0.02, 0.05)
                    headShotPlaneNode.opacity = 0
                    headShotPlaneNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.25), SCNAction.fadeOpacity(by: 1, duration: 0.25)]))
                })
            })
            
            
        }
        return self
    }
}
