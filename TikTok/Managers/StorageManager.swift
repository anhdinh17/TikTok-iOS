//
//  StorageManager.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    private init(){}
    
    public func getVideoUrl(with identifier: String, completion: @escaping (URL) -> Void){
        
    }
    
    public func uploadVideoURL(from url: URL){
        
    }
}
