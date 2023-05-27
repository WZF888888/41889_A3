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

    @IBOutlet weak var typeCodeLabel: UITextField!
    
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
            
            // Stop scanning
            captureSession.stopRunning()
        }
    }

    @IBAction func scanButtonTapped(_ sender: Any) {
        setupCamera()
    }
    
    @IBAction func markPresentButtonTapped(_ sender: Any) {
        // Check if the textfield value matches the retrieved QR code data
        let enteredText = typeCodeLabel.text
        let retrievedData = qrCodeData
        guard enteredText == qrCodeData else {
            // Show an alert when the entered text doesn't match the retrieved QR code data
            let alertController = UIAlertController(title: "Error Occurs", message: "The entered text does not match the QR code", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        // Proceed to the next view controller
        let markPresentVC = MarkPresentViewController()
        markPresentVC.qrCodeData = retrievedData
        markPresentVC.userEmail = retrievedEmail
        navigationController?.pushViewController(markPresentVC, animated: true)
    }
}
