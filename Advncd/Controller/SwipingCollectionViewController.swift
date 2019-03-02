//
//  SwipingCollectionViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseId2 = "Confirm"

class SwipingCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var selectedType = Int()
    var imagePicker = UIImagePickerController()
    
    //page control
    let pageControl = UIPageControl()
    
    //nav bar
    let cancelButton = UIButton()

    //Select type 1
    var regularImage = #imageLiteral(resourceName: "Picture")
    var regularText = ""
    
    //select type 2
    var detailedMainImage = #imageLiteral(resourceName: "Picture")
    var detailedText = ""
    var detailedPannelImageOne = #imageLiteral(resourceName: "Picture")
    var detailedPannelImageTwo = #imageLiteral(resourceName: "Picture")
    
    //select type 3
    var headShotImage = #imageLiteral(resourceName: "Resume-picture")
    var resumeImage = #imageLiteral(resourceName: "Resume-placeholder")
    
    //selected type 4
    var topLeft = #imageLiteral(resourceName: "Picture")
    var topRight = #imageLiteral(resourceName: "Picture")
    var bottomLeft = #imageLiteral(resourceName: "Picture")
    var bottomRight = #imageLiteral(resourceName: "Picture")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.collectionView!.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(ConfirmPageCollectionViewCell.self, forCellWithReuseIdentifier: reuseId2)
        collectionView.backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        imagePicker.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupPageControl()
        setupNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavBar() {
        //header component
        self.view.addSubview(cancelButton)
        cancelButton.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 42, left: 25, bottom: 0, right: 0), size: .init(width: screenWidth * 0.06, height: screenWidth * 0.06))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
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
            return 3
        }
        else if selectedType == 2 {
            return 5
        }
        else if selectedType == 3 {
            return 3
        }
        else if selectedType == 4 {
            return 5
        }
        else if selectedType == 5 {
            return 5
        }
        else {
            return 3
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PageCollectionViewCell
        self.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        if selectedType == 1 {
            pageControl.numberOfPages = 3
            if indexPath.row == 0 {
                isImage(stepLabel: "Step 1.", instructionImage: #imageLiteral(resourceName: "Regular-2"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. Click on image below.", cell: cell)
                cell.addImage.image = regularImage
            }
            else if indexPath.row == 1 {
                isText(stepLabel: "Step 2.", instructionImage: #imageLiteral(resourceName: "Regular-1"), instructionLabel: "Please input the text you'd like to display in AR for the highlighted portion. Type in textbox below.", cell: cell)
                cell.textBox.text = regularText
            }
            else if indexPath.row == 2 {
                let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId2, for: indexPath) as! ConfirmPageCollectionViewCell
                confirmCell.confirmButton.addTarget(self, action: #selector(generateQR), for: .touchUpInside)
                return confirmCell
            }
        }
        else if selectedType == 2 {
            pageControl.numberOfPages = 5
            if indexPath.row == 0 {
                isImage(stepLabel: "Step 1.", instructionImage: #imageLiteral(resourceName: "Detailed-1"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (This is the main and largest image shown)", cell: cell)
                cell.addImage.image = detailedMainImage
            }
            else if indexPath.row == 1 {
                isText(stepLabel: "Step 2.", instructionImage: #imageLiteral(resourceName: "Detailed-2"), instructionLabel: "Please input the text you'd like to display in AR for the highlighted portion. Type in textbox below.", cell: cell)
                cell.textBox.text = detailedText
            }
            else if indexPath.row == 2 {
                isImage(stepLabel: "Step 3.", instructionImage: #imageLiteral(resourceName: "Detailed-3"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (This is the top pannel image)", cell: cell)
                cell.addImage.image = detailedPannelImageOne
            }
            else if indexPath.row == 3 {
                isImage(stepLabel: "Step 4.", instructionImage: #imageLiteral(resourceName: "Detailed-4"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (This is the bottom pannel image)", cell: cell)
                cell.addImage.image = detailedPannelImageTwo
            }
            else if indexPath.row == 4 {
                let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId2, for: indexPath) as! ConfirmPageCollectionViewCell
                confirmCell.confirmButton.addTarget(self, action: #selector(generateQR), for: .touchUpInside)
                return confirmCell
            }
        }
        else if selectedType == 3 {
            pageControl.numberOfPages = 3
            if indexPath.row == 0 {
                isResume(stepLabel: "Step 1.", instructionImage: #imageLiteral(resourceName: "Resume-1"), instructionLabel: "Select a photo of yourself that you'd like to display in AR for the highlighted portion. (This is the circle)", cell: cell)
                cell.resumeImage.image = headShotImage
            }
            else if indexPath.row == 1 {
                isResumeImage(stepLabel: "Step 2.", instructionImage: #imageLiteral(resourceName: "Resume-2"), instructionLabel: "Select a photo of your resume so you can display in AR on the higlighted portion", cell: cell)
                cell.resume.image = resumeImage
            }
            else if indexPath.row == 2 {
                let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId2, for: indexPath) as! ConfirmPageCollectionViewCell
                confirmCell.confirmButton.addTarget(self, action: #selector(generateQR), for: .touchUpInside)
                return confirmCell
            }
        }
        else if selectedType == 4 {
            pageControl.numberOfPages = 5
            if indexPath.row == 0 {
                isImage(stepLabel: "Step 1.", instructionImage: #imageLiteral(resourceName: "Photo-1"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Top Left)", cell: cell)
                cell.addImage.image = topLeft
            }
            else if indexPath.row == 1 {
                isImage(stepLabel: "Step 2.", instructionImage: #imageLiteral(resourceName: "Photo-2"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Top Right)", cell: cell)
                cell.addImage.image = topRight
            }
            else if indexPath.row == 2 {
                isImage(stepLabel: "Step 3.", instructionImage: #imageLiteral(resourceName: "Photo-3"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Bottom Left)", cell: cell)
                cell.addImage.image = bottomLeft
            }
            else if indexPath.row == 3 {
                isImage(stepLabel: "Step 4.", instructionImage: #imageLiteral(resourceName: "Photo-4"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Bottom Right)", cell: cell)
                cell.addImage.image = bottomRight
            }
            else if indexPath.row == 4 {
                let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId2, for: indexPath) as! ConfirmPageCollectionViewCell
                confirmCell.confirmButton.addTarget(self, action: #selector(generateQR), for: .touchUpInside)
                return confirmCell
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: (view.frame.height * 0.94) - screenWidth * 0.06)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top, left, bottom, right
        return UIEdgeInsets(top: screenWidth * 0.07, left: 0, bottom: screenHeight * 0.06, right: 0)
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
    
    func isImage(stepLabel: String, instructionImage: UIImage, instructionLabel: String, cell: PageCollectionViewCell) {
        cell.resume.isHidden = true
        cell.addImage.isHidden = false
        cell.textBox.isHidden = true
        cell.resumeImage.isHidden = true
        cell.stepLabel.text = stepLabel
        cell.instructionImage.image = instructionImage
        cell.instructionLabel.text = instructionLabel
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.addImage.isUserInteractionEnabled = true
        cell.addImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func isResume(stepLabel: String, instructionImage: UIImage, instructionLabel: String, cell: PageCollectionViewCell) {
        cell.resume.isHidden = true
        cell.addImage.isHidden = true
        cell.textBox.isHidden = true
        cell.resumeImage.isHidden = false
        cell.stepLabel.text = stepLabel
        cell.instructionImage.image = instructionImage
        cell.instructionLabel.text = instructionLabel
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.resumeImage.isUserInteractionEnabled = true
        cell.resumeImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //for actual resume
    func isResumeImage(stepLabel: String, instructionImage: UIImage, instructionLabel: String, cell: PageCollectionViewCell) {
        cell.resume.isHidden = false
        cell.addImage.isHidden = true
        cell.textBox.isHidden = true
        cell.resumeImage.isHidden = true
        cell.stepLabel.text = stepLabel
        cell.instructionImage.image = instructionImage
        cell.instructionLabel.text = instructionLabel
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.resume.isUserInteractionEnabled = true
        cell.resume.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func isText(stepLabel: String, instructionImage: UIImage, instructionLabel: String, cell: PageCollectionViewCell) {
        cell.resume.isHidden = true
        cell.textBox.isHidden = false
        cell.textBox.delegate = self
        cell.addImage.isHidden = true
        cell.resumeImage.isHidden = true
        cell.stepLabel.text = stepLabel
        cell.instructionImage.image = instructionImage
        cell.instructionLabel.text = instructionLabel
    }
    
    @objc func generateQR() {
        if selectedType == 1 {
            if regularImage == #imageLiteral(resourceName: "Picture") || regularText == "" {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            }
        }
        else if selectedType == 2 {
            if detailedText == "" || detailedMainImage == #imageLiteral(resourceName: "Picture") || detailedPannelImageOne == #imageLiteral(resourceName: "Picture") || detailedPannelImageTwo == #imageLiteral(resourceName: "Picture") {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            }
        }
        else if selectedType == 3 {
            if headShotImage == #imageLiteral(resourceName: "Resume-picture") || resumeImage == #imageLiteral(resourceName: "Resume-placeholder") {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            }
        }
        else if selectedType == 4 {
            if topLeft == #imageLiteral(resourceName: "Picture") || topRight == #imageLiteral(resourceName: "Picture") || bottomLeft == #imageLiteral(resourceName: "Picture") || bottomRight == #imageLiteral(resourceName: "Picture") {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            }
        }
        print("generate QR code")
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != "" {
            regularText = textView.text
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
            if selectedType == 1 {
                regularImage = image
            }
            else if selectedType == 2 {
                if pageControl.currentPage == 0 {
                    detailedMainImage = image
                }
                else if pageControl.currentPage == 2 {
                    detailedPannelImageOne = image
                }
                else {
                    detailedPannelImageTwo = image
                }
            }
            else if selectedType == 3 {
                if pageControl.currentPage == 0 {
                    headShotImage = image
                }
                else if pageControl.currentPage == 1 {
                    resumeImage = image
                }
            }
            else if selectedType == 4 {
                if pageControl.currentPage == 0 {
                    topLeft = image
                }
                else if pageControl.currentPage == 1 {
                    topRight = image
                }
                else if pageControl.currentPage == 2 {
                    bottomLeft = image
                }
                else {
                    bottomRight = image
                }
            }
            
            self.collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}
