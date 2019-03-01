//
//  SwipingCollectionViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SwipingCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var selectedType = Int()
    var imagePicker = UIImagePickerController()
    
    //page control
    let pageControl = UIPageControl()

    //Regular
    var regularImage = #imageLiteral(resourceName: "Picture")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.collectionView!.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        imagePicker.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupPageControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupPageControl() {
        self.view.addSubview(pageControl)
        pageControl.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: screenWidth * 0.35, bottom: screenHeight * 0.01, right: screenWidth * 0.35), size: .init(width: screenWidth * 0.3, height: screenHeight * 0.05))
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = UIColor.FlatColor.Gray.LightIdleGray
        pageControl.currentPageIndicatorTintColor = UIColor.FlatColor.Green.LogoGreen
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedType == 1 {
            return 2
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PageCollectionViewCell
        cell.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        if selectedType == 1 {
            pageControl.numberOfPages = 2
            if indexPath.row == 0 {
                cell.addImage.isHidden = false
                cell.titleLabel.text = "Standard AR"
                cell.stepLabel.text = "Step 1."
                cell.instructionImage.image = #imageLiteral(resourceName: "Regular-1")
                cell.instructionLabel.text = "Select the image you'd like to display in AR for the highlighted portion. Click on image below."
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                cell.addImage.isUserInteractionEnabled = true
                cell.addImage.addGestureRecognizer(tapGestureRecognizer)
                cell.addImage.image = regularImage
            }
            else if indexPath.row == 1 {
                cell.textBox.isHidden = false
                cell.titleLabel.text = "Standard AR"
                cell.stepLabel.text = "Step 2."
                cell.instructionImage.image = #imageLiteral(resourceName: "Regular-2")
                cell.instructionLabel.text = "Please input the text you'd like to display in AR for the highlighted portion. Type in textbox below."
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.94)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func cancelPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "BaseVC") as! BaseViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(secondViewController, animated: true, completion: nil)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            pageControl.currentPage = indexPath.row
        }
    }

}

extension SwipingCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Options", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose from photos", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Take a picture", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            regularImage = image
            self.collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}
