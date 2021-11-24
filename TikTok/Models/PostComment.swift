//
//  PostComment.swift
//  TikTok
//
//  Created by Anh Dinh on 11/24/21.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(userName: "Eminem",
                        profilePictureUrl: nil,
                        identifier: UUID().uuidString)
        var comments = [PostComment]()
        
        var text = [
            "This is good",
            "great post",
            "I like this one"
        ]
        
        for comment in text {
            comments.append(PostComment(text: comment,
                                        user: user,
                                        date: Date()))
        }
        
        return comments
    }
}
