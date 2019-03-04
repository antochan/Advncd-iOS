//
//  GuidanceCollectionViewCell.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/5.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Lottie

class GuidanceCollectionViewCell: UICollectionViewCell {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //Title
    let title = UILabel()
    let doneButton = UIButton()
    
    //animation View
    let animationView = LOTAnimationView()
    
    //description
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        drawGuidanceCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawGuidanceCell() {
        self.addSubview(doneButton)
        doneButton.isHidden = true
        doneButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 25), size: .init(width: 45, height: 20))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.MontserratRegular(size: 13)
        doneButton.titleLabel?.textAlignment = .center
        
        self.addSubview(title)
        title.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.075, left: screenWidth * 0.25, bottom: 0, right: screenWidth * 0.25), size: .init(width: screenWidth * 0.5, height: screenHeight * 0.12))
        title.textAlignment = .center
        title.font = UIFont.MontserratSemiBold(size: 25)
        title.numberOfLines = 0
        title.textColor = .white
        
        self.addSubview(animationView)
        animationView.anchor(top: title.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.08, left: screenWidth * 0.2, bottom: 0, right: screenWidth * 0.2), size: .init(width: screenWidth * 0.6, height: screenWidth * 0.5))
        animationView.play()
        animationView.loopAnimation = true
        
        self.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: animationView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.05, left: screenWidth * 0.15, bottom: screenHeight * 0.05, right: screenWidth * 0.15))
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.MontserratRegular(size: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
    }
}
