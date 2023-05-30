//
//  QRScanViewController.swift
//  Student-App
//
//  Created by Yeseul Shin on 23/5/2023.
//

import AVFoundation
import UIKit
import Firebase

class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var qrCodeData: String?
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var retrievedEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        // Do any additional setup after loading the view.
    }
    
    func setupCamera() {
        // Setup camera to scan QR code
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
            
            captureSession.startRunning()
        } catch {
            print("Error occurs while setting up camera: \(error.localizedDescription)")
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Process scanned QR code data
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let qrCodeString = metadataObj.stringValue {
            qrCodeData = qrCodeString
            
            // Display the QR code data
            print("Scanned QR Code: \(qrCodeData ?? "")")
            
            // Stop scanning
            captureSession.stopRunning()
            
            // Remove video preview layer
            videoPreviewLayer.removeFromSuperlayer()
            
            // Navigate to MarkPresentViewController
            checkIfCollectionExists(collectionName: qrCodeData!){ exists in
                if exists {
                    let alert = UIAlertController(title: "Scan Successful!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        if let markVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarkPresentViewController") as? MarkPresentViewController {
                            markVC.qrCodeData = self.qrCodeData!
                            markVC.userEmail = self.retrievedEmail!
                            self.navigationController?.setViewControllers([markVC], animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "QR Code does not exist!", message: "Plese log in again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Sign out the student and navigate back to the login screen
                        if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                            self.navigationController?.setViewControllers([loginVC], animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func checkIfCollectionExists(collectionName: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(collectionName)

        collectionRef.getDocuments { (snapshot, error) in
            if error != nil {
                print("Error retrieving documents: (error)")
                completion(false)
                return
            }

            if snapshot?.isEmpty == true {
                // Collection does not exist
                completion(false)
            } else {
                // Collection exists
                completion(true)
            }
        }
    }
}
