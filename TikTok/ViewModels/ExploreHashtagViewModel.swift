//
//  ExploreHashtagViewModel.swift
//  TikTok
//
//  Created by Anh Dinh on 12/4/21.
//

import Foundation
import UIKit

struct ExploreHashtagViewModel {
    let text: String
    let icon: String?
    let count: Int // number of posts associtated with tag
    let handler: (() -> Void)
}
