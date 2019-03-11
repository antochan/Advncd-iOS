//
//  PagerTabViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/11.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PagerTabViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if isAppAlreadyLaunchedOnce() == false {
            showGuidance()
        }
    }

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .clear
        settings.style.buttonBarItemFont = UIFont.MontserratBold(size: 15)
        settings.style.selectedBarBackgroundColor = UIColor.FlatColor.Green.LogoGreen
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.FlatColor.Green.LogoGreen
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.FlatColor.Gray.IdleGray
            newCell?.label.textColor = UIColor.FlatColor.Green.LogoGreen
        }
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
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
    
    @IBAction func profilePressed(_ sender: Any) {
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
    
    
    @IBAction func cameraPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ARVC = storyboard.instantiateViewController(withIdentifier: "ARVC") as! ARViewController
        present(ARVC, animated: false, completion: nil)
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let Default = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseVC")
        let Custom = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomVC")
        return [Default, Custom]
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
