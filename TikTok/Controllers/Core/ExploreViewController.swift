//
//  ExploreViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        
        return bar
    }()
    
    private var sections = [ExploreSection]()
    
    private var collectionView: UICollectionView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        
        setUpCollectionView()
        
        configureModels()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    //MARK: - Functions
    
    // set up Search Bar
    func setUpSearchBar(){
        // add searchBar to Navigation Bar
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    // mocking sections array
    func configureModels(){
        
        // add to sections, this sections now have ExploreSection of type .banner and cells is an array of .banner
        // hieu don gian, type: .banner thi cells cung la array cua .banner
        sections.append(
            ExploreSection(
                type: .banners,
                cells: ExploreManager.shared.getExploreBanner().compactMap({
                    return ExploreCell.banner(viewModel: $0)
                })
            ) 
        )
        
        var posts = [ExploreCell]()
        for _ in 0...40 {
            posts.append(ExploreCell.post(viewModel: ExplorePostViewModel(thumbnailImage: UIImage(named: "onePiece"),
                                                                          caption: "This is a long greate post",
                                                                          handler: {
            })))
        }
        
        // Trending posts
        sections.append(ExploreSection(type: .trendingPosts,
                                       cells: posts))
        
        // users
        sections.append(ExploreSection(type: .users,
                                       cells: [
                                        .user(viewModel: ExploreUserViewModel(porfilePictureURL: nil,
                                                                              username: "Raymond Lam",
                                                                              followerCount: 0,
                                                                              handler: {
                                                                                  
                                                                              })),
                                        .user(viewModel: ExploreUserViewModel(porfilePictureURL: nil,
                                                                              username: "Bosco",
                                                                              followerCount: 0,
                                                                              handler: {
                                                                                  
                                                                              })),
                                        .user(viewModel: ExploreUserViewModel(porfilePictureURL: nil,
                                                                              username: "Myolie Wong",
                                                                              followerCount: 0,
                                                                              handler: {
                                                                                  
                                                                              })),
                                        .user(viewModel: ExploreUserViewModel(porfilePictureURL: nil,
                                                                              username: "Kate Tsui",
                                                                              followerCount: 0,
                                                                              handler: {
                                                                                  
                                                                              }))
                                       ]))
        
        // trending hashtags
        sections.append(ExploreSection(type: .trendingHashtags,
                                       cells: [
                                        .hashtag(viewModel: ExploreHashtagViewModel(text: "#foryou",
                                                                                    icon: UIImage(systemName: "house"),
                                                                                    count: 1,
                                                                                    handler: {
                                                                                        
                                                                                    })),
                                        .hashtag(viewModel: ExploreHashtagViewModel(text: "#iphone13",
                                                                                    icon: UIImage(systemName: "bell"),
                                                                                    count: 1,
                                                                                    handler: {
                                                                                        
                                                                                    })),
                                        .hashtag(viewModel: ExploreHashtagViewModel(text: "#tiktokcourse",
                                                                                    icon: UIImage(systemName: "camera"),
                                                                                    count: 1,
                                                                                    handler: {
                                                                                        
                                                                                    })),
                                        .hashtag(viewModel: ExploreHashtagViewModel(text: "#M1Macbook",
                                                                                    icon: UIImage(systemName: "airplane"),
                                                                                    count: 1,
                                                                                    handler: {
                                                                                        
                                                                                    }))
                                       ]))
        
        // recommended
        sections.append(ExploreSection(
            type: .recommended,
            cells: posts
        )
        )
        
        // popular
        sections.append(ExploreSection(type: .popular,
                                       cells: posts))
        
        // new/crent
        sections.append(ExploreSection(type: .new,
                                       cells: posts))
    }
    
    func setUpCollectionView(){
        
        let layout = UICollectionViewCompositionalLayout { section,_ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        // general registration
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        
        // Register tat ca cac custom file
        collectionView.register(ExploreBannerCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        collectionView.register(ExplorePostCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(ExploreUserCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        collectionView.register(ExploreHashtagCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
}

//MARK: - CollectionView Delegate, DataSource
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    // Cai ma minh muon tim
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // sections[section] = ExploreSection.type
        // sections[section].cells = array cua thang ExploreSection.cells
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Chua hieu dong nay co tac dung gi
        // sections[indexPath.section] la 1 ExploreSection
        // model la 1 enum ExploreCell
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
            
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreBannerCollectionViewCell.identifier,
                for: indexPath) as? ExploreBannerCollectionViewCell else {
                    return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                }
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExplorePostCollectionViewCell.identifier,
                for: indexPath) as? ExplorePostCollectionViewCell else {
                    return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier,
                for: indexPath) as? ExploreHashtagCollectionViewCell else {
                    return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                }
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreUserCollectionViewCell.identifier,
                for: indexPath) as? ExploreUserCollectionViewCell else {
                    return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
            
        case .banner(let viewModel):
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
    }
    
}

extension ExploreViewController: UISearchBarDelegate {}


//MARK: - Section Layouts of CollectionView
extension ExploreViewController {
    /*
     Function nay xet sectionType de xem case cua enum la gi,neu "sections" array co type la .banner thi se tao section(collectionView) nhu code, va cu nhu vay cho toi case .new
     
     thu tu xuat hien cua tung thang layout tren Collection view la do thu tu cua ExploreSection.type cua thang "sections" array. Vi du neu object dau tien cua sections co ExploreSection.type la .banner thi thang banner se xuat hien truoc tren collectionView, object tiep theo la .user thi layout cua .user xuat hien ke tiep.
     */
    func layout(for section: Int) -> NSCollectionLayoutSection {
        // sectionType is an enum
        let sectionType = sections[section].type
        
        // Voi moi case cua enum, minh tao item->group->section
        switch sectionType {
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension:.fractionalWidth(1),
                    heightDimension:.fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)),
                subitems: [item])
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging // scrolling behavior
            
            return sectionLayout
            
        case .users:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension:.fractionalWidth(1),
                    heightDimension:.fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(200)),
                subitems: [item])
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous // scrolling behavior
            
            return sectionLayout
            
        case .trendingHashtags:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension:.fractionalWidth(1),
                    heightDimension:.fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)),
                subitems: [item])
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            
            return sectionLayout
            
        case .trendingPosts,.new,.recommended:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension:.fractionalWidth(1),
                    heightDimension:.fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)),
                subitem: item,
                count: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(300)),
                subitems: [verticalGroup])
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging // scrolling behavior
            
            return sectionLayout
            
        case .popular:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension:.fractionalWidth(1),
                    heightDimension:.fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)),
                subitems: [item]
            )
            
            // Section
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging // scrolling behavior
            
            return sectionLayout
        }
    }
}
