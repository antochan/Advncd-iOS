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
    
    //table view
    let tableView = UITableView()
    
    //No data label
    let noDataLabel = UILabel()
    
    
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
        
        //table view component
        backgroundOverlay.addSubview(tableView)
        tableView.anchor(top: logo.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 8, left: screenWidth * 0.1, bottom: 0, right: screenWidth * 0.1))
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        //no data label
        backgroundOverlay.addSubview(noDataLabel)
        noDataLabel.isHidden = true
        noDataLabel.frame = CGRect(x: screenWidth * 0.1, y: screenHeight * 0.4, width: screenWidth * 0.8, height: screenHeight * 0.1)
        noDataLabel.font = UIFont.MontserratMedium(size: 14)
        noDataLabel.numberOfLines = 0
        noDataLabel.text = "No QR codes saved yet!"
        noDataLabel.textColor = UIColor.FlatColor.Gray.IdleGray
        noDataLabel.textAlignment = .center
    }

}
