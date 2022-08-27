//
//  AuthVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import UIKit
import SnapKit
import Domain

class AuthVC: BaseVC<Void, Void, AuthService> {
    
    private lazy var emailTitle: UILabel = {
        let label = UILabel()
        label.text = "Email Address"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        self.view.addSubview(label)
        return label
    }()
    
    lazy var emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 24, weight: .regular)
        self.view.addSubview(field)
        return field
    }()
    
    private lazy var passwordTitle: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        self.view.addSubview(label)
        return label
    }()
    
    lazy var passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.isSecureTextEntry = true
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 24, weight: .regular)
        self.view.addSubview(field)
        return field
    }()
    
    lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.emailTitle.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.centerX.equalToSuperview()
        }
        
        self.emailField.snp.makeConstraints { make in
            make.top.equalTo(self.emailTitle.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.centerX.equalToSuperview()
        }
        
        self.passwordTitle.snp.makeConstraints { make in
            make.top.equalTo(self.emailField.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.centerX.equalToSuperview()
        }
        
        self.passwordField.snp.makeConstraints { make in
            make.top.equalTo(self.passwordTitle.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.centerX.equalToSuperview()
        }
        
        self.registerBtn.snp.makeConstraints { make in
            make.top.equalTo(self.passwordField.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func onRegister() {
    }
}
