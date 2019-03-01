//
//  BaseCollectionViewCell.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Lottie

class BaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    let animationView = LOTAnimationView()
    let labelView = UIView()
    let animationLabel = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 8
        cardView.layer.masksToBounds = true
        cardView.backgroundColor = UIColor.FlatColor.Blue.MatDarkBlue.withAlphaComponent(1)
        
        let cardViewWidth = cardView.frame.size.width
        let cardViewHeight = cardView.frame.size.height
        
        self.addSubview(animationView)
        animationView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, padding: .init(top: 8, left: cardViewWidth * 0.05, bottom: cardViewHeight * 0.17, right: cardViewWidth * 0.05))
        animationView.loopAnimation = true
        
        self.addSubview(labelView)
        labelView.anchor(top: animationView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        labelView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        labelView.layer.masksToBounds = true

        labelView.addSubview(animationLabel)
        animationLabel.anchor(top: labelView.topAnchor, leading: labelView.leadingAnchor, bottom: labelView.bottomAnchor, trailing: labelView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 12))
        animationLabel.textColor = .white
        animationLabel.font = UIFont.MontserratMedium(size: 15)
        animationLabel.textAlignment = .center
    }

}
