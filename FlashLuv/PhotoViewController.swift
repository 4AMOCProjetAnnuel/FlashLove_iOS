//
//  PhotoViewController.swift
//  FlashLuv
//
//  Created by Henri Gil on 13/04/2018.
//  Copyright © 2018 Henri Gil. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase


class PhotoViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
     var messageLabel:UILabel!
     var topbar: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self,queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.stopRunning()
    }
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        
        let uid = code
            print(uid)
            let profileViewController = ProfileViewController()
        captureSession.stopRunning()
        let charset = CharacterSet(charactersIn: ".#$[]")
        if uid.rangeOfCharacter(from: charset) != nil {
            setupAlert()
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.exists())
            if (snapshot.exists()){
                profileViewController.uid = uid
                if let userFieldDictionnary = snapshot.value as? [String: Any]{
                    guard let counter = userFieldDictionnary["views"] as? Int else {
                        return
                    }
                    self.updateViewCount(uid: uid, counter)
                    guard let fcmToken = userFieldDictionnary["fcmToken"] as? String else {
                        return
                    }
                    CustomNotifications.sendNotication(fcmToken: fcmToken, uid: uid, from: "flash",conversationId: nil)
                self.navigationController?.pushViewController(profileViewController, animated: true)
                }
            }else{
                self.setupAlert()
            }
            
        }) { (err) in
            if err != nil {
                print("user does not exist")
            }
        }
        
    }
    
    func updateViewCount(uid : String, _ currentNumberOfViews: Int){
        let ref = Database.database().reference(fromURL: "https://flashloveapi.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        let counter = currentNumberOfViews + 1
        let values = ["views" : counter] as [String : Any]
       
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }

            print("User Modified")
        })
    }
    func setupAlert(){
        let alert = UIAlertController(title: "Erreur", message: "L'utilisateur n'existe pas", preferredStyle: .alert)
        let action = UIAlertAction(title: "Réssayer", style: .cancel, handler: { (action) in
            self.captureSession.startRunning()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
