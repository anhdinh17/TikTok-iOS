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
        var cells = [ExploreCell]()
        
        for x in 0...100 {
            let cell = ExploreCell.banner(viewModel: ExploreBannerViewModel(
                image: nil,
                title: "Foo",
                handler:{
                    
                }))
            cells.append(cell)
        }
        
        sections.append(ExploreSection(type: .banners, cells: cells))
    }
    
    func setUpCollectionView(){
        
        let layout = UICollectionViewCompositionalLayout { section,_ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    func layout(for section: Int) -> NSCollectionLayoutSection {
        // sectionType is an enum
        let sectionType = sections[section].type
        
        switch sectionType {
        case .banners:
            break
        case .trendingPosts:
            break
        case .trendingHashtags:
            break
        case .recommended:
            break
        case .popular:
            break
        case .new:
            break
        case .users:
            break
        }
        
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
    }
    
}

//MARK: - CollectionView Delegate, DataSource
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Chua hieu dong nay co tac dung gi
        let model = sections[indexPath.section].cells[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let color: [UIColor] = [
            .red, .orange, .systemPink, .darkGray, .systemGreen, .systemBlue
        ]
        cell.backgroundColor = color.randomElement()
        
        return cell
    }
    
    
}

extension ExploreViewController: UISearchBarDelegate {}
