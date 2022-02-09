//
//  AuthButton.swift
//  TikTok
//
//  Created by Anh Dinh on 2/7/22.
//

import UIKit

class AuthButton: UIButton {
    enum ButtonType {
        case signIn
        case signUp
        case plain
        var title: String {
            switch self {
            case .signIn: return "Sign In"
            case .signUp: return "Sign Up"
            case .plain: return "-"
            }
        }
    }
    
    let type: ButtonType

    // init with optional title in case if users want to give the button a title
    // or else we use the enum to set title
    init(type: ButtonType, title:String?){
        self.type = type
        super.init(frame: .zero)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureUI(){
        if type != .plain {
            setTitle(type.title, for: .normal)
        }
        setTitleColor(.white, for: .normal)
        switch type {
        case .signIn: backgroundColor = .systemBlue
        case .signUp: backgroundColor = .systemGreen
        case .plain: setTitleColor(.link, for: .normal)
            backgroundColor = .clear
        }
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
