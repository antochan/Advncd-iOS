//
//  ProfileView.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //background content
    let backgroundImage = UIImageView()
    let backgroundOverlay = UIView()
    
    //nav bar items
    let backButton = UIButton()
    let logoutButton = UIButton()
    let logo = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        drawProfile()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawProfile()
    }
    
    func drawProfile() {
        //Background Component
        self.addSubview(backgroundImage)
        backgroundImage.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = #imageLiteral(resourceName: "background")
        
        self.addSubview(backgroundOverlay)
        backgroundOverlay.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundOverlay.backgroundColor = UIColor.FlatColor.Blue.DarkBlue.withAlphaComponent(0.95)
        
        backgroundOverlay.addSubview(backButton)
        backButton.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 42, left: 25, bottom: 0, right: 0), size: .init(width: screenWidth * 0.06, height: screenWidth * 0.06))
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        
        backgroundOverlay.addSubview(logoutButton)
        logoutButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 42, left: 0, bottom: 0, right: 25), size: .init(width: screenWidth * 0.06, height: screenWidth * 0.06))
        logoutButton.setImage(#imageLiteral(resourceName: "logout"), for: .normal)
        
        backgroundOverlay.addSubview(logo)
        logo.frame = CGRect(x: screenWidth * 0.325, y: 0, width: screenWidth * 0.35, height: screenWidth * 0.35)
        logo.image = #imageLiteral(resourceName: "Logo")
    }

}
