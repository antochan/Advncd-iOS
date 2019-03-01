//
//  BaseViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    let baseView = BaseView()
    let cellId = "BaseCell"
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        baseView.collectionView.delegate = self
        baseView.collectionView.dataSource = self
        let nib = UINib(nibName: "BaseCollectionViewCell", bundle: nil)
        baseView.collectionView.register(nib, forCellWithReuseIdentifier: cellId)
        
        baseView.profileButton.addTarget(self, action: #selector(profilePressed), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func profilePressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(profileVC, animated: false, completion: nil)
    }

}

extension BaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! BaseCollectionViewCell
        if indexPath.row == 0 {
            cell.animationView.setAnimation(named: "Regular")
            cell.animationView.play(fromProgress: 0, toProgress: 0.11, withCompletion: nil)
            cell.animationLabel.text = "Standard AR"
        }
        else if indexPath.row == 1 {
            cell.animationView.setAnimation(named: "Details")
            cell.animationView.play(fromProgress: 0, toProgress: 0.1, withCompletion: nil)
            cell.animationLabel.text = "Detailed AR"
        }
        else if indexPath.row == 2 {
            cell.animationView.setAnimation(named: "Resume")
            cell.animationView.play(fromProgress: 0, toProgress: 0.125, withCompletion: nil)
            cell.animationLabel.text = "Resume AR"
        }
        else if indexPath.row == 3 {
            cell.animationView.setAnimation(named: "Photos")
            cell.animationView.play(fromProgress: 0, toProgress: 0.1, withCompletion: nil)
            cell.animationLabel.text = "Photos AR"
        }
        else if indexPath.row == 4 {
            cell.animationView.setAnimation(named: "Gallery")
            cell.animationView.play(fromProgress: 0, toProgress: 0.125, withCompletion: nil)
            cell.animationLabel.text = "Gallery AR"
        }
        else if indexPath.row == 5 {
            cell.animationView.setAnimation(named: "Card")
            cell.animationView.play(fromProgress: 0, toProgress: 0.11, withCompletion: nil)
            cell.animationLabel.text = "Card AR"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            transitionToSwiping(selectedType: 1)
        }
        else if indexPath.row == 1 {
            transitionToSwiping(selectedType: 2)
        }
        else if indexPath.row == 2 {
            transitionToSwiping(selectedType: 3)
        }
        else if indexPath.row == 3 {
            transitionToSwiping(selectedType: 4)
        }
        else if indexPath.row == 4 {
            transitionToSwiping(selectedType: 5)
        }
        else if indexPath.row == 5 {
            transitionToSwiping(selectedType: 6)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        return CGSize(width: viewWidth * 0.4, height: viewHeight * 0.275)
    }
    
    func transitionToSwiping(selectedType: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingVC = storyboard.instantiateViewController(withIdentifier: "SwipingVC") as! SwipingCollectionViewController
        swipingVC.collectionView.collectionViewLayout = layout
        swipingVC.selectedType = selectedType
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(swipingVC, animated: true, completion: nil)
    }
}
