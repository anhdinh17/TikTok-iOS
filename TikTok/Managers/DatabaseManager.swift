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
    public func insertPost(fileName: String, caption: String, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            /*
            -----value/snapshot.value is the dictionary tree under username in Realtime Database
            -----voi insertPost() nay, khi chua co node "posts", minh tao o khuc duoi nay chu kho tao trong khu guard-else, vi minh nghi luc nay la tao them node moi o duoi node da co roi.
             */
            
            // create the structure of the "post"
            let newEntry = [
                "name": fileName,
                "caption": caption
            ]
            // Nếu đã có dictionary "posts" rồi
            if var posts = value["posts"] as? [[String:Any]]{
                // append a new video id, caption to array
                posts.append(newEntry)
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
                // Nếu chưa có node "posts", thì tạo node "post"
                // node "post" sẽ là array of dictionary of newEntry that we create above
                // fileName là id của từng thằng video
                // Mình set value của posts là array of Dictionary --> [newEntry] --> Cai nay la structure minh muon cho thang "posts"
                value["posts"] = [newEntry]
                // setValue(value) to create data -- this is syntax
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
    
    public func getPosts(for user: User, completion: @escaping([PostModel])->Void){
        
        let path = "users/\(user.userName.lowercased())/posts"
        
        database.child(path).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let posts = snapshot.value as? [[String: String]] else {
                completion([])
                return
            }
            
            // syntax moi
            let model: [PostModel] = posts.compactMap({
                // voi moi element, tao 1 instance cua PostModel
                var model = PostModel(identifier: UUID().uuidString,
                                      user: user)
                model.fileName = $0["name"] ?? ""
                model.caption = $0["caption"] ?? ""
                return model
            })
            
            completion(model)
        }
    }
    
    // Func to get notifications
    public func getNotifications(completion: @escaping([Notification])->Void){
        completion(Notification.mockData())
    }
    
    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool)->Void){
        completion(true)
    }
    
    public func getAllUsers(completion: @escaping ([String]) -> Void){
        
    }
    
    public func follow(username: String, completion: @escaping (Bool)->Void){
        completion(true)
    }
    
    
    
}
//=======================================================================================================
//MARK: NOTES
//=======================================================================================================
/*
                [username:[String:Any]]
 
                post
*/
/*
Cách tạo data trong realtime Database, chú ý quan trọng là cái structure mà mình tự tạo ra để data sắp xếp theo ý mình muốn.
Trong realtime Database, mình có thể set data trong mỗi node theo ý mình, i.e dictionary or array of dictionary. Trong insertUser: data dưới node "users" là dictionary [username:[String:Any]]. Trong insertPost: data dưới "post" là array of dictionary: [newEntry] (newEntry là 1 dictionary)
*/
