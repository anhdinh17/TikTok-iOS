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
    var forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        // scroll vertically
        navigationOrientation: .vertical,
        options: [:])
    
    // Following screen
    // Create a UIPageController
    var followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        // scroll vertically
        navigationOrientation: .vertical,
        options: [:])
    
    // Create an UISegmentControll
    let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.backgroundColor = .clear
        control.selectedSegmentIndex = 1 // the right segment
        
        return control
    }()
    
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
        // deleage of UIScrollView
        horizontalScrollView.delegate = self
        
        setUpFeed()
        
        setUpHeaderButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    //MARK: - Functions
    func setUpHeaderButtons(){
        control.addTarget(self, action: #selector(didChangeSegmentControl(_ :)), for: .valueChanged)
        // Add segment to nav bar
        navigationItem.titleView = control
    }
    
    // if segmentedIndex = 1, màn hình điện thoại(SCROLLVIEW) sẽ là ở bên For you, cũng tức là ở bên UIPageVC của For you
    // if segmentedIndex = 0 thì ngược lại
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl){
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                                                      y: 0),
                                              animated: true)
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
        // This is the first VC appear on screen
        guard let model = followingPosts.first else {
            return
        }
        
        let vc = PostViewController(model: model)
        vc.delegate = self // to use protocol from PostViewController
        followingPageViewController.setViewControllers(
            [vc],
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

        let vc = PostViewController(model: model)
        vc.delegate = self // to use protocol from PostViewController
        forYouPageViewController.setViewControllers(
            [vc],
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
        vc.delegate = self // to use protocol from PostViewController
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
        vc.delegate = self // to use protocol from PostViewController
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

//MARK: - UIScrollView Delegate
extension HomeViewController: UIScrollViewDelegate {
    // Func is to tell what happens when we scroll ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        // if you half way scroll to the left or you are at the left of ScrollView already, then change segmentIndex to 1
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width/2) {
            control.selectedSegmentIndex = 0
        }
        // if you half way scroll to the right, then change segmentIndex to 1
        else if scrollView.contentOffset.x > (view.width/2){
            control.selectedSegmentIndex = 1
        }
    }
}

//MARK: - PostViewController Protocol
extension HomeViewController: PostViewControllerDelegate{
    
    /*
     Func nay la de khi bam vao comment button, a comment area will pop up on the screen
     **/
    func postViewControllerDelegate(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        
        // cannot scroll vertically
        horizontalScrollView.isScrollEnabled = false
        
        // don't let pageViewController scroll up or down either ScrollView is on the left or right
        if horizontalScrollView.contentOffset.x == 0 {
            followingPageViewController.dataSource = nil
        } else {
            forYouPageViewController.dataSource = nil
        }
        
        // create a CommentsVC and add it to HomeVC
        let vc = CommentsViewController(post: post)
        vc.delegate = self // to use Protocol form CommentsViewController
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0,
                               y: view.height,
                               width: view.width,
                               height: view.height * 0.75)
        vc.view.frame = frame
        // animation to pop up commnent vc
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0,
                                   y: self.view.height - frame.height,
                                   width: frame.width,
                                   height:  frame.height)
        }
        /*
        Chua hieu tai sao can vc.view.frame and UIView.animate()
        **/
    }
    
    // This func execute delegate when tapping on profile button
    func postViewControllerDelegate(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let user = post.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - CommentsViewController Protocol
extension HomeViewController: CommentsViewControllerDelegate {
    
    // This func is to close comment are when clicking on close button, and let us be able to scroll after closing comment area
    func didTapCloseForComments(with viewController: CommentsViewController) {
        // close comments with animation
        // Chua hieu tai sao lai lam nhu vay
        let frame = viewController.view.frame
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame =  CGRect(x: 0,
                                                y: self.view.height,
                                                width: frame.width,
                                                height: frame.height)
        }completion: { [weak self] done in
            if done {
                DispatchQueue.main.async {
                    // remove comment vc as child
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    // allow horizontal and vertically scroll
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPageViewController.dataSource = self
                    self?.followingPageViewController.dataSource = self
                }
            }
        }
    }
}

//MARK: - NOTE
/*
 Reasons why for every local object of PostViewController we have to set it to be the delegate:
 Think about it, when we start the app, we should be either on the left or on the right of the ScrollView, which means for each starting followingPageViewController or forYouPageViewController, we have to set the delegate for the PostViewController to use the protocol of clicking the Comment Button.
 The same thing applies for scrolling to the next PageViewController, we need to set the next or the prior PostViewController to be the delegate to use the Comment Button protocol.
**/
