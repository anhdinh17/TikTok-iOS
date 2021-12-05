//
//  ExploreSectionType.swift
//  TikTok
//
//  Created by Anh Dinh on 12/2/21.
//

import Foundation

enum ExploreSectionType: CaseIterable {
    case banners
    case trendingPosts
    case trendingHashtags
    case recommended
    case popular
    case new
    case users
    
    var title: String {
        switch self {
        
        case .banners:
            return "Featured"
        case .trendingPosts:
            return "Trending Posts"
        case .users:
            return "Popular Creators"
        case .trendingHashtags:
            return "Hashtags"
        case .recommended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"
        }
    }
}
