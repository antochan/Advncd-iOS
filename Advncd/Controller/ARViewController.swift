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
    
    //loading component
    let loadingViewBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let qrProgressCircle = UICircularProgressRing(frame: CGRect(x: UIScreen.main.bounds.width * 0.3, y: (UIScreen.main.bounds.height * 0.5) - (UIScreen.main.bounds.width * 0.3), width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.4))
    let loadingLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.7, width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.12))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configuration.trackingImages = self.ARTrackingImages
        configuration.maximumNumberOfTrackedImages = 1
        self.sceneView.session.run(configuration)
    }
    
//    func setupLoadingView() {
//        DispatchQueue.main.async {
//            self.loadingViewBackground.backgroundColor = UIColor.FlatColor.Blue.DarkBlue
//            self.loadingViewBackground.addSubview(self.loadingLabel)
//
//            self.loadingViewBackground.addSubview(self.qrProgressCircle)
//            self.qrProgressCircle.minValue = 0
//            self.qrProgressCircle.maxValue = 100
//            self.qrProgressCircle.outerRingColor = UIColor.FlatColor.Green.LogoGreen
//            self.qrProgressCircle.innerRingColor = .white
//            self.qrProgressCircle.innerRingWidth = 5
//            self.qrProgressCircle.fontColor = .white
//            self.qrProgressCircle.font = UIFont.MontserratMedium(size: 16)
//
//            self.loadingLabel.textColor = .white
//            self.loadingLabel.numberOfLines = 0
//            self.loadingLabel.text = "Downloading QR Codes from server. This may take a while!"
//            self.loadingLabel.textAlignment = .center
//            self.loadingLabel.font = UIFont.MontserratRegular(size: 15)
//        }
//    }
//
//    func getAllQRCodes(completion: @escaping CompletionHandler) {
//            var downloaded = 0
//            let reference = Database.database().reference().child("QR")
//            reference.observe(DataEventType.value, with: { (snapshot) in
//                let postDict = snapshot.value as? [String : String] ?? [:]
//                DispatchQueue.global(qos: .background).async {
//                    for (key, value) in postDict {
//                        print("downloaded: \(downloaded) / total: \(postDict.count)")
//                        let percentage = (Double(downloaded)/Double(postDict.count)) * 100
//                        DispatchQueue.main.async {
//                            self.qrProgressCircle.startProgress(to: CGFloat(percentage), duration: 1)
//                        }
//                        if self.downloadURLs.contains(value) == false {
//                            self.downloadURLs.insert(value)
//                            let qrImage = UIImage(url: URL(string: value))
//                            let qrCiImage = CIImage(image: qrImage!)
//                            let qrCGImage = self.convertCIImageToCGImage(inputImage: qrCiImage!)
//                            let qrARImage = ARReferenceImage(qrCGImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
//                            qrARImage.name = key
//                            self.ARTrackingImages.insert(qrARImage)
//                            downloaded += 1
//                        }
//                    }
//                completion(true)
//                }
//            })
//    }
    
    func getIdentifiedQR(qrId: String, completion: @escaping CompletionHandler) {
        let reference = Database.database().reference().child("QR")
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let downloadURL = value?[qrId] as? String {
                if self.downloadURLs.contains(downloadURL) == false {
                    self.downloadURLs.insert(downloadURL)
                    let qrImage = UIImage(url: URL(string: downloadURL))
                    let qrCiImage = CIImage(image: qrImage!)
                    let qrCGImage = self.convertCIImageToCGImage(inputImage: qrCiImage!)
                    let qrARImage = ARReferenceImage(qrCGImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
                    qrARImage.name = qrId
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
        let image = CIImage(cvPixelBuffer: frame.capturedImage)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        let features = detector!.features(in: image)
        
        for feature in features as! [CIQRCodeFeature] {
            if !discoveredQRCodes.contains(feature.messageString!) {
                discoveredQRCodes.append(feature.messageString!)
                print(feature.messageString!)
                if let qrId = feature.messageString {
                    getIdentifiedQR(qrId: qrId) { (success) in
                        if success {
                            self.restartSession()
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
