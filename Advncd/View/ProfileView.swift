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
    
    //nav bar items
    let backButton = UIButton()
    let logoutButton = UIButton()
    let titleLabel = UILabel()
    
    
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
        self.addSubview(backButton)
        backButton.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 42, left: 20, bottom: 0, right: 0), size: .init(width: screenWidth * 0.075, height: screenWidth * 0.075))
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        
        self.addSubview(logoutButton)
        logoutButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 42, left: 0, bottom: 0, right: 20), size: .init(width: screenWidth * 0.075, height: screenWidth * 0.075))
        logoutButton.setImage(#imageLiteral(resourceName: "logout"), for: .normal)
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, leading: backButton.trailingAnchor, bottom: nil, trailing: logoutButton.leadingAnchor, padding: .init(top: 42, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: screenWidth * 0.075))
        titleLabel.font = UIFont.MainFontMedium(size: 22)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Profile"
    }

}
