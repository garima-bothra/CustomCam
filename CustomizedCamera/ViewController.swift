//
//  ViewController.swift
//  CustomizedCamera
//
//  Created by Garima Bothra on 03/05/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //Create variables
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    @IBOutlet weak var previewView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5) as! CGColor
        setupCaptureSession()
        setupDevice() { result in
            if(result){
                self.setupInputOutput()
                self.setupPreviewLayer()
                self.startRunningCaptureSession()
            }
        }
        // Do any additional setup after loading the view.
    }

    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        print("Capture Setup")
    }

    func setupDevice(completion: @escaping(Bool) -> ()) {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
                currentCamera = device
                print(device)
            }
            else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        print("Device setup")
        completion(true)
    }

    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        } catch {
            print(error)
        }
        print("setupInputOutput")
    }

    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer! , at: 0)
        print("Setup preview layer")
    }

    func startRunningCaptureSession() {
        captureSession.startRunning()

    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       // Setup your camera here...
    }

    @IBAction func ClickImageButtonPressed(_ sender: Any) {
    }


}

