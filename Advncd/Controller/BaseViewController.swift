//
//  BaseViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import AudioToolbox
import Firebase

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let baseView = BaseView()
    let cellId = "BaseCell"
    var isOverQuota = false
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAppAlreadyLaunchedOnce() == false {
            showGuidance()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        baseView.collectionView.delegate = self
        baseView.collectionView.dataSource = self
        let nib = UINib(nibName: "BaseCollectionViewCell", bundle: nil)
        baseView.collectionView.register(nib, forCellWithReuseIdentifier: cellId)
        baseView.profileButton.addTarget(self, action: #selector(profilePressed), for: .touchUpInside)
        baseView.cameraButton.addTarget(self, action: #selector(cameraPressed), for: .touchUpInside)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        baseView.collectionView.addGestureRecognizer(lpgr)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
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
    
    @objc func cameraPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ARVC = storyboard.instantiateViewController(withIdentifier: "ARVC") as! ARViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(ARVC, animated: false, completion: nil)
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .began {
            return
        }
        let p = gesture.location(in: baseView.collectionView)
        
        if let indexPath = baseView.collectionView.indexPathForItem(at: p) {
            // get the cell at indexPath (the one you long pressed)
            let cell = baseView.collectionView.cellForItem(at: indexPath) as! BaseCollectionViewCell
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            // do stuff with the cell
            cell.animationView.loopAnimation = false
            cell.animationView.play(toProgress: 1) { (repeated) in
                cell.animationView.play(fromProgress: 0, toProgress: 0.5) { (success) in
                    cell.animationView.pause()
                }
            }
        } else {
            return
        }
    }
    
    func getUserQRCodes(uid: String) {
    }

}

extension BaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! BaseCollectionViewCell
        if indexPath.row == 0 {
            cell.animationView.setAnimation(named: "Standard")
            cell.animationView.play(fromProgress: 0.5, toProgress: 0.5, withCompletion: nil)
            cell.animationLabel.text = "Standard AR"
        }
        else if indexPath.row == 1 {
            cell.animationView.setAnimation(named: "Detailed")
            cell.animationView.play(fromProgress: 0.5, toProgress: 0.5, withCompletion: nil)
            cell.animationLabel.text = "Detailed AR"
        }
        else if indexPath.row == 2 {
            cell.animationView.setAnimation(named: "Resume")
            cell.animationView.play(fromProgress: 0.5, toProgress: 0.5, withCompletion: nil)
            cell.animationLabel.text = "Resume AR"
        }
        else if indexPath.row == 3 {
            cell.animationView.setAnimation(named: "Photos")
            cell.animationView.play(fromProgress: 0.5, toProgress: 0.5, withCompletion: nil)
            cell.animationLabel.text = "Photos AR"
        }
        else if indexPath.row == 4 {
            cell.animationView.setAnimation(named: "Gallery")
            cell.animationView.play(fromProgress: 0.5, toProgress: 0.5, withCompletion: nil)
            cell.animationLabel.text = "Gallery AR"
        }
        else if indexPath.row == 5 {
            cell.animationView.setAnimation(named: "Card")
            cell.animationView.play(fromProgress: 0.5, toProgress: 0.5, withCompletion: nil)
            cell.animationLabel.text = "Card AR"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        QRServices.instance.getUserQRCodes(uid: (Auth.auth().currentUser?.uid)!) { (success) in
            if success {
                if QRServices.instance.userQRCodes.count >= 3 {
                    UIViewController.removeSpinner(spinner: sv)
                    self.displayAlert(title: "You're over limit!", message: "Unfortunately you've made 3 or more QR codes already. Please contact me personally if you'd like more! :)")
                    return
                } else {
                    UIViewController.removeSpinner(spinner: sv)
                    if indexPath.row == 0 {
                        self.transitionToSwiping(selectedType: 1)
                    }
                    else if indexPath.row == 1 {
                        self.transitionToSwiping(selectedType: 2)
                    }
                    else if indexPath.row == 2 {
                        self.transitionToSwiping(selectedType: 3)
                    }
                    else if indexPath.row == 3 {
                        self.transitionToSwiping(selectedType: 4)
                    }
                    else if indexPath.row == 4 {
                        self.transitionToSwiping(selectedType: 5)
                    }
                    else if indexPath.row == 5 {
                        self.transitionToSwiping(selectedType: 6)
                    }
                }
            } else {
                self.displayAlert(title: "Error!", message: "Error with fetching data from server. Please check connection.")
                UIViewController.removeSpinner(spinner: sv)
            }
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
    
    func showGuidance() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let guidanceVC = storyboard.instantiateViewController(withIdentifier: "GuidanceVC") as! GuidanceCollectionViewController
        guidanceVC.collectionView.collectionViewLayout = layout
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(guidanceVC, animated: true, completion: nil)
    }
}
