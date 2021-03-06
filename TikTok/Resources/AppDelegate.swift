//
//  AppDelegate.swift
//  TikTok
//
//  Created by Anh Dinh on 11/2/21.
//

import UIKit
import Firebase
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // This is for running the app without MainStory Board
        let window = UIWindow(frame: UIScreen.main.bounds)
        // Set tabBarVC to be root VC
        window.rootViewController = TabBarViewController()
        self.window = window
        self.window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
//        do{
//            try Auth.auth().signOut()
//        }catch{
//            print("Error: \(Error.self)")
//        }
        
//        AuthManager.shared.signOut { _ in
//            
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

