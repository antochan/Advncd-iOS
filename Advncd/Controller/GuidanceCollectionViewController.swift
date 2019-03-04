//
//  GuidanceCollectionViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/5.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GuidanceCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let guidanceAnimationName = ["Guidance-0","Guidance-1","Guidance-2","Guidance-3","Guidance-4"]
    let guidanceTitle = ["Watch The Animation!", "Upload Anything!", "Generate your QR Code", "Scan the QR Code!", "Share with Anyone!"]
    let guidanceDescriptions = ["Click and hold on each image to watch how the AR will be displayed in animation!",
                                "Follow the steps and upload your images and texts to populate your own custom AR experience!",
                                "You will generate a QR code once you've completed all the steps.",
                                "Click on the camera icon on the homepage to scan your own QR code or even scan what your friend's QR Code!",
                                "All QR Codes created on the app will be scannable so feel free to share your creation with your friends and family! Enjoy! :)"]
    
    //page control
    let pageControl = UIPageControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        // Register cell classes
        self.collectionView!.register(GuidanceCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        collectionView.isPagingEnabled = true
        setupPageControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupPageControl() {
        self.view.addSubview(pageControl)
        pageControl.numberOfPages = guidanceTitle.count
        pageControl.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: screenWidth * 0.35, bottom: screenHeight * 0.01, right: screenWidth * 0.35), size: .init(width: screenWidth * 0.3, height: screenHeight * 0.05))
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = UIColor.FlatColor.Gray.LightIdleGray
        pageControl.currentPageIndicatorTintColor = UIColor.FlatColor.Green.LogoGreen
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guidanceAnimationName.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GuidanceCollectionViewCell
        cell.doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        
        cell.title.text = guidanceTitle[indexPath.row]
        
        cell.animationView.setAnimation(named: guidanceAnimationName[indexPath.row])
        cell.animationView.play()
        cell.animationView.loopAnimation = true
        cell.descriptionLabel.text = guidanceDescriptions[indexPath.row]
        
        if indexPath.row == guidanceDescriptions.count - 1 {
            cell.doneButton.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.94)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top, left, bottom, right
        return UIEdgeInsets(top: 0, left: 0, bottom: screenHeight * 0.06, right: 0)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
        pageControl.currentPage = self.collectionView.getNearestVisibleCollectionViewCell()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
            pageControl.currentPage = self.collectionView.getNearestVisibleCollectionViewCell()
        }
    }
    
    @objc func donePressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "BaseVC") as! BaseViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        UserDefaults.standard.set(true, forKey: "Guidance")
        present(secondViewController, animated: true, completion: nil)
    }
    
}
