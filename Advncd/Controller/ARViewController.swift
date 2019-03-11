//
//  ARViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import ARKit
import Firebase
import SDWebImage
import FirebaseUI
import FirebaseDatabase
import Lottie
import UICircularProgressRing
import Vision


class ARViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var downloadURLs = Set<String>()
    var ARTrackingImages = Set<ARReferenceImage>()
    let configuration = ARImageTrackingConfiguration()
    var discoveredQRCodes = [String]()
    
    var time = 0.0
    var timer = Timer()
    
    //loading component
    let loadingViewBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let loadingLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width * 0.1, y: (UIScreen.main.bounds.height * 0.5) - (UIScreen.main.bounds.width * 0.1), width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.1))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configuration.trackingImages = self.ARTrackingImages
        configuration.maximumNumberOfTrackedImages = 1
        self.sceneView.session.run(configuration)
        startTimer()
    }
    
        func setupLoadingView() {
            DispatchQueue.main.async {
                self.sceneView.addSubview(self.loadingViewBackground)
                self.loadingViewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.85)
                self.loadingViewBackground.addSubview(self.loadingLabel)
                self.loadingLabel.textColor = .white
                self.loadingLabel.numberOfLines = 0
                self.loadingLabel.text = "Found New QR Code! Displaying AR..."
                self.loadingLabel.textAlignment = .center
                self.loadingLabel.font = UIFont.MontserratRegular(size: 16)
            }
        }

    func getIdentifiedQR(qrId: String, completion: @escaping CompletionHandler) {
        let reference = Database.database().reference().child("QR")
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let parsedId = qrId.replacingOccurrences(of: "https://advncd-ar.com/", with: "")
            if let downloadURL = value?[parsedId] as? String {
                if self.downloadURLs.contains(downloadURL) == false {
                    self.downloadURLs.insert(downloadURL)
                    let qrImage = UIImage(url: URL(string: downloadURL))
                    let qrCiImage = CIImage(image: qrImage!)
                    let qrCGImage = self.convertCIImageToCGImage(inputImage: qrCiImage!)
                    let qrARImage = ARReferenceImage(qrCGImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
                    qrARImage.name = parsedId
                    self.ARTrackingImages.insert(qrARImage)
                }
                completion(true)
            }
        }) { (error) in
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        let scene = SCNScene()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.scene = scene
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getStandardText(qrId: String) -> String {
        let reference = Firestore.firestore().collection("Texts").document("\(qrId)_Main")
        var standardText = ""
        reference.getDocument { (document, error) in
            if let document = document, document.exists {
                standardText = document.data()!["text"] as! String
            }
        }
        return standardText
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func resetTimer() {
        timer.invalidate()
        time = 0
        startTimer()
    }
    
    @objc func updateTime() {
        if time < 0.5 {
           time += 0.1
        } else {
            resetTimer()
        }
    }

}

extension ARViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        if let unfilteredName = imageAnchor.name {
            let filteredNameArray = unfilteredName.components(separatedBy: "_")
            let qrId = filteredNameArray[0]
            let selectedType = filteredNameArray[1]
            
            if selectedType == "Standard" {
                return node.RegularARNode(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Detailed" {
                return node.DetailedNodeAR(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Resume" {
                return node.ResumeNode(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Photos" {
                return node.PhotosNode(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Gallery" {
                return node.GalleryNode(uuid: qrId, selectedType: selectedType)
            }
            else if selectedType == "Card" {
                return node.CardNode(uuid: qrId, selectedType: selectedType)
            }
        }
        return nil
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if time != 0.5 {
            return
        }
        let image = CIImage(cvPixelBuffer: frame.capturedImage)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        let features = detector!.features(in: image)
        for feature in features as! [CIQRCodeFeature] {
            if !self.discoveredQRCodes.contains(feature.messageString!) {
                self.discoveredQRCodes.append(feature.messageString!)
                self.setupLoadingView()
                if let qrId = feature.messageString {
                    self.getIdentifiedQR(qrId: qrId) { (success) in
                        if success {
                            self.restartSession()
                            self.loadingViewBackground.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    
    func restartSession() {
        self.sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        configuration.trackingImages = self.ARTrackingImages
        configuration.maximumNumberOfTrackedImages = 1
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}
