//
//  DatabaseManager.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init(){}
    
    public func getAllUsers(completion: @escaping ([String]) -> Void){
        
    }
}

