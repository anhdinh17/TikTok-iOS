//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import Foundation
import FirebaseAuth
import AVFoundation
import UIKit

final class AuthManager {
    public static let shared = AuthManager()
    
    private init(){}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    // check if user signed in or not
    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    // Error Enum
    enum AuthError: Error {
        case signInFailed
    }

    //=======================================================================================================
    //MARK: Functions
    //=======================================================================================================
    
    // Func to sign in using email, password, completion tra ve 1 Result<>
    public func signIn(with email: String,
                       password: String,
                       completion: @escaping (Result<String,Error>)->Void){
        // Auth framwork func to sign in
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            
            DatabaseManager.shared.getUsername(for: email) { username in
                if let username = username {
                    UserDefaults.standard.set(username, forKey: "username")
                    print("Got username: \(username)")
                }
            }
            
            // Neu sign in thanh cong (result != nil)
            // Tra ve 1 String(email) cho success case
            completion(.success(email))
        }
    }
    
    public func signUp(
        with username: String,
        emailAddress: String,
        password: String,
        completion: @escaping (Bool)->Void){
            // Using Firebase Authentication framework to create accout
            Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
                guard result != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
            
            UserDefaults.standard.set(username, forKey: "username")
            
            // After creating account, add that email and username into Firebase Database
            DatabaseManager.shared.insertUser(with: emailAddress, username: username, completion: completion)
    }
    
    public func signOut(completion: (Bool)->Void){
        do {
            try Auth.auth().signOut()
            completion(true)
        }catch{
            print(error)
            completion(false)
        }
    }
    
}
