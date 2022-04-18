//
//  CaptionViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 4/2/22.
//

import ProgressHUD
import UIKit
import ProgressHUD

class CaptionViewController: UIViewController {
    
    let videoURL: URL
    
    init(videoURL:URL){
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done
                                                            , target: self, action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //=======================================================================================================
    //MARK: Functions
    //=======================================================================================================
    @objc func didTapPost(){
        // Generate a video name that is unique based on id
        let newVideoName = StorageManager.shared.generateVideoName()
        ProgressHUD.show("Posting")
        // Upload video to Storage
        StorageManager.shared.uploadVideo(from: videoURL, fileName: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // Update database in Realtime Database
                    DatabaseManager.shared.insertPost(fileName: newVideoName) { databaseUpdated in
                        if databaseUpdated{
                            HapticsManager.shared.vibrate(for: .success)
                            ProgressHUD.dismiss()
                            // Reset camera and switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                            ProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Error Inserting video into Database", message: "Cannot insert this video into Database", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self?.present(alert, animated: true)
                        }
                    }
                } else {
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error Uploading Video", message: "Sorry, we are not able to upload your video", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
}
