//
//  QRScanViewController.swift
//  Student-App
//
//  Created by Yeseul Shin on 23/5/2023.
//

import AVFoundation
import UIKit

class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
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
        }
    }
    
    @IBAction func markPresentButtonTapped(_ sender: Any) {
        // Proceed to the next view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuVC = storyboard.instantiateViewController(withIdentifier: "MarkPresentViewController") as! MarkPresentViewController
        MenuVC.qrCodeData = qrCodeData!
        MenuVC.userEmail = retrievedEmail!
        self.present(MenuVC, animated: true, completion: nil)
    }
}
