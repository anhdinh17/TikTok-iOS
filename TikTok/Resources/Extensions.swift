//
//  Extensions.swift
//  TikTok
//
//  Created by Anh Dinh on 11/12/21.
//

import Foundation
import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
}

/*
 The 2 extensions below are used to convert a Date() to String
**/
extension DateFormatter {
    static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
}

extension String {
    static func date(with date: Date) -> String{
        return DateFormatter.defaultFormatter.string(from: date)
    }
}
