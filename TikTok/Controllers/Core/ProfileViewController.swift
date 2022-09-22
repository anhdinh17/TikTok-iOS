//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit
import ProgressHUD

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ProfileHeaderCollectionReusableViewDelegate{
//MARK: - Properties
    enum PicturePickerType {
        case camera
        case photoLibrary
    }
    
    var user: User
    
    var isCurrentUserProfile: Bool {
        if let username = UserDefaults.standard.string(forKey: "username") {
            return user.userName.lowercased() == username.lowercased()
        }
        return false
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PostCollectionViewCell.self,
                                forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        // Register for collectionView Header
        collectionView.register(ProfileHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        return collectionView
    }()
    
    private var posts = [PostModel]()
    private var followers = [String]()
    private var following = [String]()
    
    //MARK: - Initialization
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.userName
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let username = UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "Me"
        // we show gear button if current profile is of ourself.
        if title == username {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(didTapSettings))
        }
        
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    //MARK: - Actions
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchPosts(){
        DatabaseManager.shared.getPosts(for: user) { [weak self] postModels in
            DispatchQueue.main.async {
                self?.posts = postModels
                self?.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier,
                                                      for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.width - 12)/3
        return CGSize(width: width, height: width * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Open a post
        let post = posts[indexPath.row]
        let vc = PostViewController(model: post)
        vc.title = "Video"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // CollectionView Header
    // this func is to dequeue header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.delegate = self
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        DatabaseManager.shared.getRelationships(for: user,
                                                type: .followers) { [weak self] followers in
            defer {
                group.leave()
            }
            self?.followers = followers
        }
        DatabaseManager.shared.getRelationships(for: user,
                                                type: .following) { [weak self] following in
            defer {
                group.leave()
            }
            self?.following = following
        }
        group.notify(queue: .main) { [weak self] in
            // if isFollowing is nil -> current logged in user
            // if isFollowing is Bool -> someone's profile
            let viewModel = ProfileHeaderViewModel(avatarImageURL: self?.user.profilePictureUrl,
                                                   followerCount: self?.followers.count ?? 0,
                                                   followingCount: self?.following.count ?? 0,
                                                   isFollowing: (self?.isCurrentUserProfile ?? false) ? nil : false)
            
            // khi run func nay, property "viewModel" cua ProfileHeaderCollectionReusableView
            // se duoc set bang viewModel minh moi tao o tren.
            // dan toi khi click vao nut following/followers, delegate func se co duoc viewModel de xai
            header.configure(with: viewModel)
        }

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}

//MARK: - Profile Header Delegate
extension ProfileViewController {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {return}
        
        if self.user.userName == currentUsername {
            // Edit profile
        } else {
            // Follow or unfollow current users profile that we are viewing
        }
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(user: user, type: .followers)
        vc.users = self.followers
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(user: user, type: .following)
        vc.users = self.following
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel) {
        guard isCurrentUserProfile else {
            return
        }
        let actionSheet = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {_ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .photoLibrary)
            }
        }))
        present(actionSheet,animated: true)
    }
    
    // This func is not from delegate
    func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
}

//=======================================================================================================
//MARK: UIImagePicker
//=======================================================================================================
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // This is the image we choose from photo library
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        // show uploading spinning thing
        ProgressHUD.show("Uploading")
        
        // upload and update UI
        StorageManager.shared.uploadProfileImage(with: image) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                switch result {
                // When successfully receive image url
                case .success(let downloadUrl):
                    // set value for the url string to use it later.
                    // this will be used when we close the app and reopen it, we need an url string to set up User object for ProfileViewController in TabBarVC.
                    UserDefaults.standard.setValue(downloadUrl.absoluteString, forKey: "profile_picture_url")
                    
                    // reinit the user with download image url
                    strongSelf.user = User(userName: strongSelf.user.userName,
                                     profilePictureUrl: downloadUrl,
                                     identifier: strongSelf.user.userName)
                    // reload collectionView so that it can use the new image url and set the header image for avatar
                    strongSelf.collectionView.reloadData()
                    
                    ProgressHUD.showSucceed("Updated")
                case .failure:
                    ProgressHUD.showError("Failed to upload profile picture")
                }
            }
        }
    }
}

extension ProfileViewController: PostViewControllerDelegate {
    func postViewControllerDelegate(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        // Present comments
    }
    
    func postViewControllerDelegate(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        // Push another profile
    }
    
    
}
