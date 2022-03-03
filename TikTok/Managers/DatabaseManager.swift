//
//  DatabaseManager.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import Foundation
import FirebaseDatabase
import UIKit

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init(){}
    
    public func createRootUser(){
        // Tạo root node "users" với 1 child node
        database.child("users").setValue(
            [
                "emai": "anhdinh17@gmail.com"
            ]
        )
    }
    
    public func insertUser(with email: String, username:String, completion: @escaping(Bool)->Void){
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            print("This is snapshot: \(snapshot)")
            print("Snapshot.value: \(snapshot.value)")
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                // create users root node if we don't have the root node "users" yet.
                self?.database.child("users").setValue(
                    // this is the structure we want
                    [
                        username:[
                            "emai": email
                        ]
                    ]
                ){error,_ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }
            // set new username node and its dictionary "email": email address
            usersDictionary[username] = ["email":email]
            // save new users object (username node and its value)
            // save new username---email: "email address"
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    public func getAllUsers(completion: @escaping ([String]) -> Void){
        
    }
}

