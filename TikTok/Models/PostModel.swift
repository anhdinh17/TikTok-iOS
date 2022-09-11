//
//  PostModel.swift
//  TikTok
//
//  Created by Anh Dinh on 11/16/21.
//

import Foundation

struct PostModel {
    let identifier: String
    var isLikeByCurrentUser = false
    let user: User
    var fileName: String = ""
    var caption: String = ""
    
    // the path of a video post
    var videoChildPath: String {
        return "videos/\(user.userName.lowercased())/\(fileName)"
    }
    
    // debug/mocking func
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString,
                                 user: User(userName:"Kanye West",
                                            profilePictureUrl: nil,
                                            identifier: UUID().uuidString))
            posts.append(post)
        }
        
        return posts
        
    }
}
