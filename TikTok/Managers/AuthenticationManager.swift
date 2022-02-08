//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import Foundation
import FirebaseAuth

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
    
    public func signIn(with method: SignInMethod){
        
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
