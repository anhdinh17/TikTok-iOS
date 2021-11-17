//
//  ViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/2/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Create a UIScrollView
    let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .red
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // For-you screen
    // Create a UIPageController
    let forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        // scroll vertically
        navigationOrientation: .vertical,
        options: [:])
    
    // Following screen
    // Create a UIPageController
    let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        // scroll vertically
        navigationOrientation: .vertical,
        options: [:])
    
    // Array of PostModel objects
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .link
        
        view.addSubview(horizontalScrollView)
        // set the start of ScrollView when we first launch the app. In this case, when we start the app, scrollView is on the right of the content, and we can scroll left.
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        
        setUpFeed()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    //MARK: - Functions
    private func setUpFeed(){
        /* SIZE OF SCROLLVIEW:
         width: view.width * 2 because we have 2 controllers to be scrolled horizontally
         */
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    func setUpFollowingFeed(){
        // This is the first VC appear on screen
        guard let model = followingPosts.first else {
            return
        }
        
        followingPageViewController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward,
            animated: false,
            completion: nil)
        
        followingPageViewController.dataSource = self
        
        // add UIPageVC to ScrollView
        horizontalScrollView.addSubview(followingPageViewController.view)
        // Vị trí bắt đầu của thằng UIPageVC này nằm bên trái
        followingPageViewController.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        // có add paging to Home thì mới kéo được
        // dòng này giống như present(pagingVC, animated: true, completion: nil) trong playground.
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self) // add pagingController to HomeVC
    }
    
    func setUpForYouFeed(){
        // This is the first VC appear on screen
        guard let model = forYouPosts.first else {
            return
        }

        forYouPageViewController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward,
            animated: false,
            completion: nil)

        forYouPageViewController.dataSource = self

        horizontalScrollView.addSubview(forYouPageViewController.view)
        // Vị trí bắt đầu của thằng UIPageVC này nằm ở bên phải
        forYouPageViewController.view.frame = CGRect(x: view.width,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self) // add pagingController to HomeVC
    }
    
}

//MARK: - DataSource of UIPageViewController
extension HomeViewController: UIPageViewControllerDataSource {
    // This func is to go back to prior page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // fromPost là 1 PostModel object
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        // make sure that we talking about the same PostModel
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        // if the position is the first PageVC
        if index == 0 {
            return nil
        }
        let priorIndex = index - 1
        // get PostModel from prior element
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        
        return vc
        
    }
    
    // the next VC that we scroll to
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // fromPost là 1 PostModel object
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        // make sure that we talking about the same PostModel
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        // if the position is the last PageVC
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        let nextIndex = index + 1
        // get PostModel from prior element
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        
        return vc
    }
    
    var currentPosts: [PostModel] {
        // nếu scrollView ở bên trái thì return array of followingPosts
        if horizontalScrollView.contentOffset.x == 0 {
            return followingPosts
        }
        
        // Nếu scrollView ở bên phải thì return array of forYouPosts.
        return forYouPosts
    }
}
