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
        label.font = FontFamily.RobotoMono.bold.font(size: 24)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray3.cgColor
        field.layer.cornerRadius = 12
        field.textAlignment = .center
        field.font = FontFamily.RobotoMono.regular.font(size: 20)
        self.view.addSubview(field)
        return field
    }()
    
    private lazy var passwordTitle: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textAlignment = .center
        label.font = FontFamily.RobotoMono.bold.font(size: 24)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray3.cgColor
        field.layer.cornerRadius = 12
        field.isSecureTextEntry = true
        field.textAlignment = .center
        field.font = FontFamily.RobotoMono.regular.font(size: 20)
        self.view.addSubview(field)
        return field
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textAlignment = .center
        label.font = FontFamily.RobotoMono.bold.font(size: 20)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = FontFamily.RobotoMono.bold.font(size: 20)
        btn.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = FontFamily.RobotoMono.bold.font(size: 20)
        btn.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.orLabel.snp.makeConstraints { make in
            make.top.equalTo(self.passwordField.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
        }
        
        self.loginBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.orLabel.snp.centerY)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(32)
            make.right.equalTo(self.orLabel.snp.left).offset(-16)
        }
        
        self.registerBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.orLabel.snp.centerY)
            make.left.equalTo(self.orLabel.snp.right).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-32)
        }
    }
    
    override func observe(state: AuthState) {
        switch state {
        case .login(let isVerified):
            if isVerified {
                self.navigationProvider.tabBarDelegate.updateLoginState()
                self.popVC()
            } else {
                self.showVerifyAlert()
            }
        case .register:
            self.showVerifyAlert()
        case .logout:
            break
        }
    }
    
    func showVerifyAlert() {
        let alert = UIAlertController(title: "Verify your email", message: "Please verify your email with link sent, then login.", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in
                self.popVC()
            }
        )
        self.present(alert, animated: true)
    }

    @objc private func onRegister() {
        guard let email = self.emailField.text,
              let password = self.passwordField.text
        else { return }
        
        Task {
            await self.service.register(email, password)
        }
    }
    
    @objc private func onLogin() {
        guard let email = self.emailField.text,
              let password = self.passwordField.text
        else { return }
        
        Task {
            await self.service.login(email, password)
        }
    }
}
