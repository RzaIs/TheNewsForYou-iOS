//
//  AuthVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import UIKit
import SnapKit
import Domain

class AuthVC: BaseVC<AuthState, Void, AuthService> {
    
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
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
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
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.isSecureTextEntry = true
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 24, weight: .regular)
        self.view.addSubview(field)
        return field
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onLogin(_:)))
        )
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onRegister(_:)))
        )
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
        
        self.loginBtn.snp.makeConstraints { make in
            make.top.equalTo(self.passwordField.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.centerX.equalToSuperview()
        }
        
        self.registerBtn.snp.makeConstraints { make in
            make.top.equalTo(self.loginBtn.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(32)
            make.centerX.equalToSuperview()
        }
    }
    
    override func observe(state: AuthState) {
        switch state {
        case .success:
            self.popVC()
        }
    }

    @objc private func onRegister(_ sender: UITapGestureRecognizer) {
        guard let email = self.emailField.text,
              let password = self.passwordField.text
        else { return }
        
        Task {
            await self.service.register(email, password)
        }
    }
    
    @objc private func onLogin(_ sender: UITapGestureRecognizer) {
        guard let email = self.emailField.text,
              let password = self.passwordField.text
        else { return }
        
        Task {
            await self.service.login(email, password)
        }
    }
}
