//
//  TabBarViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    private var signInPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented{
            presentSignInIfNeeded()
        }
    }
    
    func presentSignInIfNeeded(){
        // if user is not signed in
        if !AuthManager.shared.isSignedIn{
            signInPresented = true
            let vc = SignInViewController()
            // van chua hieu tai sao can completion nay
            //----> tạm hiểu: sau khi tạo SignInVC xong và đi đến đó, trả lại signInPresented thành false
            vc.completion = {[weak self] in
                self?.signInPresented = false
            }
            // set SignInVC to be root of navigation bar.
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC,animated: false,completion: nil)
        }
    }
    
    // This func is to set up tab bar
    private func setUpControllers(){
        
        // this is used to get url string of profile image
        // After we set the image for profile, if we close the app and rerun, we don't see new profile image
        // that's why we need to set this below so that every time we open the app,
        // we have the latest profile image
        var urlString: String?
        if let cachedUrlString = UserDefaults.standard.string(forKey: "profile_picture_url"){
            urlString = cachedUrlString
        }
        
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifications = NotificationsViewController()
        let profile = ProfileViewController(
            user: User(userName: UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "Me",
                       profilePictureUrl: URL(string: urlString ?? ""),
                       identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""))
        
        home.title = "Home"
        notifications.title = "Notifications"
        profile.title = "Profile"
        
        // đưa vào navBar
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notifications)
        let nav4 = UINavigationController(rootViewController: profile)
        let cameraNav = UINavigationController(rootViewController: camera)
        
        // Set image for each item
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "safari"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)
        
        // Make nav1 clear background color
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()
        
        // Make cameraNav clear background color
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .white
        
        // change tint color of navigation bar of nav3
        nav3.navigationBar.tintColor = .label
        // change tint color of navigation bar of nav4
        nav4.navigationBar.tintColor = .label
        
        /*  we can use this way to set up tab bar items if we don't want navigationBar
         
        home.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        explore.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "safari"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        notifications.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)
         
         */
        
        if #available(iOS 14.0, *) {
            nav1.navigationBar.topItem?.backButtonDisplayMode = .minimal
            nav2.navigationBar.topItem?.backButtonDisplayMode = .minimal
            nav3.navigationBar.topItem?.backButtonDisplayMode = .minimal
            nav4.navigationBar.topItem?.backButtonDisplayMode = .minimal
            cameraNav.navigationBar.topItem?.backButtonDisplayMode = .minimal
        }
        
        // Set the order of tab bar items
        setViewControllers([nav1,nav2,cameraNav,nav3,nav4], animated: false)
        
    }
    
}
