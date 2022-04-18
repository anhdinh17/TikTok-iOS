//
//  StorageManager.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    public static let shared = StorageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    private init(){}
    
    public func getVideoUrl(with identifier: String, completion: @escaping (URL) -> Void){
        
    }
    
    // Upload video to Storage in Firebase
    public func uploadVideo(from url: URL,fileName: String, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        // Save video under the path of "video/username/fileName"
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { (_,error) in
            // return True
            completion(error == nil)
        }
    }
    
    // Create a name for the video in a form of unique id
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...10000)
        let unixTimeStamp = Date().timeIntervalSince1970
        return uuidString + "_\(number)" + "\(unixTimeStamp)" + ".mov"
    }
}
