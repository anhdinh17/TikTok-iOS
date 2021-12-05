//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by Anh Dinh on 12/4/21.
//

import Foundation
import UIKit

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
