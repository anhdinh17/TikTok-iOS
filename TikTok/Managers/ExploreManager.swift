//
//  ExploreManager.swift
//  TikTok
//
//  Created by Anh Dinh on 12/27/21.
//

import Foundation
import UIKit

final class ExploreManager {
    static let shared = ExploreManager()
    
    public func getExploreBanner() -> [ExploreBannerViewModel]{
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        // cach return nay hay
        // exploreData.banners.compactMap tra ve 1 array cua ExploreBannerViewModel
        return exploreData.banners.compactMap({
            ExploreBannerViewModel(
                image: UIImage(named: $0.image),
                title: $0.title) {
                    // empty for now
                }
        })
    }
    
    private func parseExploreData() -> ExploreResponse? {
        // fetch data from a json file in "Resource" folder
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return nil
        }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ExploreResponse.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
}

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}

struct Banner: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Post: Codable {
    let id: String
    let image: String
    let caption: String
}

struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: Int
}

struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}
