//
//  AuthField.swift
//  TikTok
//
//  Created by Anh Dinh on 2/7/22.
//

import UIKit

class AuthField: UITextField {
    
    enum FieldType {
        case email
        case password
        case username
        var title: String {
            switch self {
            case .email: return "Email Address"
            case .password: return "Password"
            case .username: return "User Name"
            }
        }
    }
    
    private let type: FieldType
    
    // init dien type
    init(type: FieldType){
        self.type = type
        // init to create .zero frame if we create a textField out of this class
        super.init(frame: .zero)
        // run configureUI() func when initialized.
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // set up what textField is gonna be like
    func configureUI(){
        autocapitalizationType = .none
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        if type == .password{
            isSecureTextEntry = true
            textContentType = .oneTimeCode
        } else if type == .email {
            keyboardType = .emailAddress
            textContentType = .emailAddress
        }
    }
}
