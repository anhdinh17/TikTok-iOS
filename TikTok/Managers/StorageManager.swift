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

    // Upload video to Storage in Firebase
    public func uploadVideo(from url: URL,fileName: String, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        // Save video under the path of "videos/username/fileName"
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
    
    // Upload a profile image to Firebase Storage
    // Func nay co nghia la khi upload image len Firebase roi, completion se tra ve 1 url cua image do
    public func uploadProfileImage(with image: UIImage, completion: @escaping (Result<URL,Error>) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        // get the image under png format
        guard let imageData = image.pngData() else {return}
        
        // This is the directory the image gonna stays
        // every time we run this func, we gonna overwrite this path
        let path = "profile_pictures/\(username)/picture.png"
        
        // upload data(image) to Firebase Storage with the specified path
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                // if successfully upload data,
                // we download the url of the image.
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        // if downloadURL gets error
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    // tra ve 1 url
                    completion(.success(url))
                }
            }
        }
        
    }
    
}
