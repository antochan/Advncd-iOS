//
//  SwipingCollectionViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

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
    var standardImage = #imageLiteral(resourceName: "Picture")
    var standardText = ""
    
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
    
    //selected type 5
    var galleryMain = #imageLiteral(resourceName: "Picture")
    var subGallery1 = #imageLiteral(resourceName: "Picture")
    var subGallery2 = #imageLiteral(resourceName: "Picture")
    var subGallery3 = #imageLiteral(resourceName: "Picture")
    
    //selected type 6
    var cardImage = #imageLiteral(resourceName: "Resume-picture")
    var cardText = ""
    
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
                cell.addImage.image = standardImage
            }
            else if indexPath.row == 1 {
                isText(stepLabel: "Step 2.", instructionImage: #imageLiteral(resourceName: "Regular-1"), instructionLabel: "Please input the text you'd like to display in AR for the highlighted portion. Type in textbox below.", cell: cell)
                cell.textBox.text = standardText
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
                isCircularImage(stepLabel: "Step 1.", instructionImage: #imageLiteral(resourceName: "Resume-1"), instructionLabel: "Select a photo of yourself that you'd like to display in AR for the highlighted portion. (Use square image for best rendering)", cell: cell)
                cell.circularImage.image = headShotImage
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
        else if selectedType == 5 {
            pageControl.numberOfPages = 5
            if indexPath.row == 0 {
                isImage(stepLabel: "Step 1.", instructionImage: #imageLiteral(resourceName: "Gallery-1"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Main Photo)", cell: cell)
                cell.addImage.image = galleryMain
            }
            else if indexPath.row == 1 {
                isImage(stepLabel: "Step 2.", instructionImage: #imageLiteral(resourceName: "Gallery-2"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Bottom Left)", cell: cell)
                cell.addImage.image = subGallery1
            }
            else if indexPath.row == 2 {
                isImage(stepLabel: "Step 3.", instructionImage: #imageLiteral(resourceName: "Gallery-3"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Bottom Mid)", cell: cell)
                cell.addImage.image = subGallery2
            }
            else if indexPath.row == 3 {
                isImage(stepLabel: "Step 4.", instructionImage: #imageLiteral(resourceName: "Gallery-4"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Bottom Right)", cell: cell)
                cell.addImage.image = subGallery3
            }
            else if indexPath.row == 4 {
                let confirmCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId2, for: indexPath) as! ConfirmPageCollectionViewCell
                confirmCell.confirmButton.addTarget(self, action: #selector(generateQR), for: .touchUpInside)
                return confirmCell
            }
        }
        else if selectedType == 6 {
            pageControl.numberOfPages = 3
            if indexPath.row == 0 {
                isCircularImage(stepLabel: "Step 1.", instructionImage: #imageLiteral(resourceName: "Card-1"), instructionLabel: "Select the image you'd like to display in AR for the highlighted portion. (Use square image for best rendering)", cell: cell)
                cell.circularImage.image = cardImage
            }
            else if indexPath.row == 1 {
                isText(stepLabel: "Step 2.", instructionImage: #imageLiteral(resourceName: "Card-2"), instructionLabel: "Please input the text you'd like to display in AR for your card. Type in textbox below.", cell: cell)
                cell.textBox.text = cardText
            } else if indexPath.row == 2 {
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
        cell.circularImage.isHidden = true
        cell.stepLabel.text = stepLabel
        cell.instructionImage.image = instructionImage
        cell.instructionLabel.text = instructionLabel
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.addImage.isUserInteractionEnabled = true
        cell.addImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func isCircularImage(stepLabel: String, instructionImage: UIImage, instructionLabel: String, cell: PageCollectionViewCell) {
        cell.resume.isHidden = true
        cell.addImage.isHidden = true
        cell.textBox.isHidden = true
        cell.circularImage.isHidden = false
        cell.stepLabel.text = stepLabel
        cell.instructionImage.image = instructionImage
        cell.instructionLabel.text = instructionLabel
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.circularImage.isUserInteractionEnabled = true
        cell.circularImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //for actual resume
    func isResumeImage(stepLabel: String, instructionImage: UIImage, instructionLabel: String, cell: PageCollectionViewCell) {
        cell.resume.isHidden = false
        cell.addImage.isHidden = true
        cell.textBox.isHidden = true
        cell.circularImage.isHidden = true
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
        cell.circularImage.isHidden = true
        cell.stepLabel.text = stepLabel
        cell.instructionImage.image = instructionImage
        cell.instructionLabel.text = instructionLabel
    }
    
    @objc func generateQR() {
        if selectedType == 1 {
            if standardImage == #imageLiteral(resourceName: "Picture") || standardText == "" {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            } else {
                let sv = UIViewController.displaySpinner(onView: self.view)
                let uuid = UUID().uuidString
                uploadImageToFirebase(data: standardImage.jpegData(compressionQuality: 0.75)!, selectedType: "Standard", imageType: "Main", uuid: uuid)
                textUpload(uuid: uuid, selectedType: "Standard", textType: "Main", text: standardText)
                transitionToQR(uuid: uuid, selectedType: "Standard")
                UIViewController.removeSpinner(spinner: sv)
            }
        }
        else if selectedType == 2 {
            if detailedText == "" || detailedMainImage == #imageLiteral(resourceName: "Picture") || detailedPannelImageOne == #imageLiteral(resourceName: "Picture") || detailedPannelImageTwo == #imageLiteral(resourceName: "Picture") {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            } else {
                let sv = UIViewController.displaySpinner(onView: self.view)
                let uuid = UUID().uuidString
                uploadImageToFirebase(data: detailedMainImage.jpegData(compressionQuality: 0.75)!, selectedType: "Detailed", imageType: "Main", uuid: uuid)
                uploadImageToFirebase(data: detailedPannelImageOne.jpegData(compressionQuality: 0.75)!, selectedType: "Detailed", imageType: "PannelTop", uuid: uuid)
                uploadImageToFirebase(data: detailedPannelImageTwo.jpegData(compressionQuality: 0.75)!, selectedType: "Detailed", imageType: "PannelBottom", uuid: uuid)
                textUpload(uuid: uuid, selectedType: "Detailed", textType: "Main", text: detailedText)
                transitionToQR(uuid: uuid, selectedType: "Standard")
                UIViewController.removeSpinner(spinner: sv)
            }
        }
        else if selectedType == 3 {
            if headShotImage == #imageLiteral(resourceName: "Resume-picture") || resumeImage == #imageLiteral(resourceName: "Resume-placeholder") {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            } else {
                let sv = UIViewController.displaySpinner(onView: self.view)
                let uuid = UUID().uuidString
                uploadImageToFirebase(data: headShotImage.jpegData(compressionQuality: 0.75)!, selectedType: "Resume", imageType: "Headshot", uuid: uuid)
                uploadImageToFirebase(data: resumeImage.jpegData(compressionQuality: 0.75)!, selectedType: "Resume", imageType: "Resume", uuid: uuid)
                transitionToQR(uuid: uuid, selectedType: "Resume")
                UIViewController.removeSpinner(spinner: sv)
            }
        }
        else if selectedType == 4 {
            if topLeft == #imageLiteral(resourceName: "Picture") || topRight == #imageLiteral(resourceName: "Picture") || bottomLeft == #imageLiteral(resourceName: "Picture") || bottomRight == #imageLiteral(resourceName: "Picture") {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            } else {
                let sv = UIViewController.displaySpinner(onView: self.view)
                let uuid = UUID().uuidString
                uploadImageToFirebase(data: topLeft.jpegData(compressionQuality: 0.75)!, selectedType: "Photos", imageType: "TopLeft", uuid: uuid)
                uploadImageToFirebase(data: topLeft.jpegData(compressionQuality: 0.75)!, selectedType: "Photos", imageType: "TopRight", uuid: uuid)
                uploadImageToFirebase(data: topLeft.jpegData(compressionQuality: 0.75)!, selectedType: "Photos", imageType: "BottomLeft", uuid: uuid)
                uploadImageToFirebase(data: topLeft.jpegData(compressionQuality: 0.75)!, selectedType: "Photos", imageType: "BottomRight", uuid: uuid)
                transitionToQR(uuid: uuid, selectedType: "Photos")
                UIViewController.removeSpinner(spinner: sv)
            }
        }
        else if selectedType == 5 {
            if galleryMain == #imageLiteral(resourceName: "Picture") || subGallery1 == #imageLiteral(resourceName: "Picture") || subGallery2 == #imageLiteral(resourceName: "Picture") || subGallery3 == #imageLiteral(resourceName: "Picture")  {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            } else {
                let sv = UIViewController.displaySpinner(onView: self.view)
                let uuid = UUID().uuidString
                uploadImageToFirebase(data: galleryMain.jpegData(compressionQuality: 0.75)!, selectedType: "Gallery", imageType: "Main", uuid: uuid)
                uploadImageToFirebase(data: subGallery1.jpegData(compressionQuality: 0.75)!, selectedType: "Gallery", imageType: "BottomLeft", uuid: uuid)
                uploadImageToFirebase(data: subGallery2.jpegData(compressionQuality: 0.75)!, selectedType: "Gallery", imageType: "BottomMid", uuid: uuid)
                uploadImageToFirebase(data: subGallery3.jpegData(compressionQuality: 0.75)!, selectedType: "Gallery", imageType: "BottomRight", uuid: uuid)
                transitionToQR(uuid: uuid, selectedType: "Gallery")
                UIViewController.removeSpinner(spinner: sv)
            }
        }
        else if selectedType == 6 {
            if cardImage == #imageLiteral(resourceName: "Resume-picture") || cardText == "" {
                displayAlert(title: "Error!", message: "We've noticed you didn't fill out everything! Please do!")
                return
            } else {
                let sv = UIViewController.displaySpinner(onView: self.view)
                let uuid = UUID().uuidString
                uploadImageToFirebase(data: cardImage.jpegData(compressionQuality: 0.75)!, selectedType: "Card", imageType: "Main", uuid: uuid)
                textUpload(uuid: uuid, selectedType: "Card", textType: "Main", text: detailedText)
                transitionToQR(uuid: uuid, selectedType: "Card")
                UIViewController.removeSpinner(spinner: sv)
            }
        }
    }
    
    func uploadImageToFirebase(data: Data, selectedType: String, imageType: String, uuid: String) {
        let storageRef = Storage.storage().reference().child(selectedType).child("\(uuid)_\(imageType).jpg")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            if let err = error {
                self.displayAlert(title: "Error uploading", message: err.localizedDescription)
                return
            }
        }
    }
    
    func textUpload(uuid: String, selectedType: String, textType: String, text: String) {
        let reference = Firestore.firestore().collection("Texts").document("\(uuid)_\(textType)")
        reference.setData([
            "text": text
        ]) { err in
            if let err = err {
                self.displayAlert(title: "Error uploading", message: err.localizedDescription)
                return
            }
        }
    }
    
    func transitionToQR(uuid: String, selectedType: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let qrVC = storyboard.instantiateViewController(withIdentifier: "QRCodeVC") as! QRCodeViewController
        qrVC.uuid = uuid
        qrVC.selectedType = selectedType
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(qrVC, animated: true, completion: nil)
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
            if selectedType == 1 {
               standardText = textView.text
            }
            else if selectedType == 2 {
                detailedText = textView.text
            }
            else if selectedType == 6 {
                cardText = textView.text
            }
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
                standardImage = image
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
            else if selectedType == 5 {
                if pageControl.currentPage == 0 {
                    galleryMain = image
                }
                else if pageControl.currentPage == 1 {
                    subGallery1 = image
                }
                else if pageControl.currentPage == 2 {
                    subGallery2 = image
                }
                else {
                    subGallery3 = image
                }
            }
            else if selectedType == 6 {
                if pageControl.currentPage == 0 {
                    cardImage = image
                }
            }
            
            self.collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}
