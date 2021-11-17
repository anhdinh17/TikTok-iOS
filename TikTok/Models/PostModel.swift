//
//  PostModel.swift
//  TikTok
//
//  Created by Anh Dinh on 11/16/21.
//

import Foundation

struct PostModel {
    let identifier: String
    
    // debug/mocking func
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        
        return posts
        
    }
}
