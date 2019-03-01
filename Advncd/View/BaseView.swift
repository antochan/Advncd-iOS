//
//  BaseView.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //background content
    let backgroundImage = UIImageView()
    let backgroundOverlay = UIView()
    
    //nav bar items
    let profileButton = UIButton()
    let cameraButton = UIButton()
    let logo = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        drawBase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawBase()
    }
    
    func drawBase() {
        //Background Component
        self.addSubview(backgroundImage)
        backgroundImage.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = #imageLiteral(resourceName: "background")
        
        self.addSubview(backgroundOverlay)
        backgroundOverlay.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundOverlay.backgroundColor = UIColor.FlatColor.Blue.DarkBlue.withAlphaComponent(0.95)
        
        backgroundOverlay.addSubview(profileButton)
        profileButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 42, left: 0, bottom: 0, right: 25), size: .init(width: screenWidth * 0.06, height: screenWidth * 0.06))
        profileButton.setImage(#imageLiteral(resourceName: "avatar-white"), for: .normal)
        
        backgroundOverlay.addSubview(cameraButton)
        cameraButton.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 42, left: 25, bottom: 0, right: 0), size: .init(width: screenWidth * 0.06, height: screenWidth * 0.06))
        cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        
        backgroundOverlay.addSubview(logo)
        logo.frame = CGRect(x: screenWidth * 0.325, y: 0, width: screenWidth * 0.35, height: screenWidth * 0.35)
        logo.image = #imageLiteral(resourceName: "Logo")

    }
    
}
