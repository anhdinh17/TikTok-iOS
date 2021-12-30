//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Anh Dinh on 12/4/21.
//

import Foundation
import UIKit

struct ExploreUserViewModel {
    let porfilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}

