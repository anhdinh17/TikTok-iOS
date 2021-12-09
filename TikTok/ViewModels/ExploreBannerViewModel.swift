//
//  ExploreBannarViewModel.swift
//  TikTok
//
//  Created by Anh Dinh on 12/4/21.
//

import Foundation
import UIKit

struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}
