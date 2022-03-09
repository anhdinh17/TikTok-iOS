//
//  CameraViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    // Capture Session
    var captureSession = AVCaptureSession()
    
    // Capture Device
    var videoCaptureDevice: AVCaptureDevice?
    
    // Capture Output - where the video gets written into as you start recording
    var captureOutput = AVCaptureMovieFileOutput()
    
    // Capture Preview - where you real time see the camera output
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    // Create a view for the camera
    private lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    //=======================================================================================================
    //MARK: Initialization
    //=======================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraView)
        view.backgroundColor = .systemBackground
        setupCamera()
        // close button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
    }

    //=======================================================================================================
    //MARK: Functions
    //=======================================================================================================
    func setupCamera(){
        // Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }

        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }

        // update session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {

            captureSession.addOutput(captureOutput)
        }

        // configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }

        // Enable camera start
        captureSession.startRunning()
    }
    
    @objc func didTapClose(){
        // stop the capture video
        captureSession.stopRunning()
        tabBarController?.tabBar.isHidden = false
        // switch to main tab
        tabBarController?.selectedIndex = 0
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            return
        }
        print("Finished recording to url: \(outputFileURL.absoluteString)")
    }
}
