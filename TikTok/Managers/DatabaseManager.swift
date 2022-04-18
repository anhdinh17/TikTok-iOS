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
    
    // Func to get the username associated with the email
    public func getUsername(for email: String, completion: @escaping (String?)->Void){
        // go to "users" tree, get values from it
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            // [String:[String:Any]] is the structure of the tree
            guard let users = snapshot.value as? [String:[String:Any]] else {
                completion(nil)
                return
            }
            
            // check if the input email = email from the "users" tree, then we get the username accordingly.
            for (username, value) in users {
                if value["email"] as? String == email {
                    completion(username)
                    break
                }
            }
        }
    }
    
    /**
    Insert a video into Realtime Database
    */
    public func insertPost(fileName: String, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            /*
            value/snapshot.value is the dictionary tree under username in Realtime Database
             */
            
            // Nếu đã có dictionary "posts" rồi
            if var posts = value["posts"] as? [String]{
                // append a new video id to array
                posts.append(fileName)
                value["posts"] = posts
                // set value mới cho path này
                self?.database.child("users").child(username).setValue(value){ error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else {
                // Nếu chưa có dictionary "posts"
                // fileName là id của từng thằng video
                // value của posts là array of String.
                value["posts"] = [fileName]
                self?.database.child("users").child(username).setValue(value){ error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    public func getAllUsers(completion: @escaping ([String]) -> Void){
        
    }
}
//=======================================================================================================
//MARK: NOTE
//=======================================================================================================
/*
                [username:[String:Any]]
 
                post
*/
