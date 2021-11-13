//
//  ViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/2/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .red
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .link
        
        view.addSubview(horizontalScrollView)
        
        setUpFeed()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    private func setUpFeed(){
        /* SIZE OF SCROLLVIEW:
         width: view.width * 2 because we have 2 controllers to be scrolled horizontally
         */
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    func setUpFollowingFeed(){
        // For-you screen
        // Create a UIPageController
        let pagingController = UIPageViewController(
            transitionStyle: .scroll,
            // scroll vertically
            navigationOrientation: .vertical,
            options: [:])
        
        // This is the first VC appear on screen
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
        pagingController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil)
        
        pagingController.dataSource = self
        
        horizontalScrollView.addSubview(pagingController.view)
        pagingController.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        addChild(pagingController)
        pagingController.didMove(toParent: self) // add pagingController to HomeVC
    }
    
    func setUpForYouFeed(){
        // For-you screen
        // Create a UIPageController
        let pagingController = UIPageViewController(
            transitionStyle: .scroll,
            // scroll vertically
            navigationOrientation: .vertical,
            options: [:])
        
        // This is the first VC appear on screen
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
        pagingController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil)
        
        pagingController.dataSource = self
        
        horizontalScrollView.addSubview(pagingController.view)
        pagingController.view.frame = CGRect(x: view.width,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        addChild(pagingController)
        pagingController.didMove(toParent: self) // add pagingController to HomeVC
    }
    
}

//MARK: - DataSource of UIPageViewController
extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    // the next VC that we scroll to
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = [UIColor.gray, UIColor.systemPink, UIColor.purple].randomElement()
        return vc
    }
    
    
}
