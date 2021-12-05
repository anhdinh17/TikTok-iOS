//
//  ExploreCell.swift
//  TikTok
//
//  Created by Anh Dinh on 12/2/21.
//

import Foundation
import UIKit

enum ExploreCell {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
}




