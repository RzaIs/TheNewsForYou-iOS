//
//  ProfileVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 24.09.22.
//

import UIKit
import SnapKit
import Domain

class ProfileVC: BaseVC<AuthState, Void, AuthService> {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner
        ]
        view.layer.cornerRadius = 24
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onClose))
        )
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = FontFamily.RobotoMono.bold.font(size: 16)
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(
            UIImage(systemName: "xmark.circle.fill")?
                .withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        btn.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        btn.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        self.containerView.addSubview(btn)
        return btn
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.RobotoMono.medium.font(size: 14)
        let labelText = NSMutableAttributedString()
        labelText.append(
            NSAttributedString(string: "Logged in as ", attributes: [
                .foregroundColor: UIColor.black
            ])
        )
        labelText.append(
            NSAttributedString(string: self.service.userEmail, attributes: [
                .foregroundColor: UIColor.blue
            ])
        )
        label.attributedText = labelText
        label.textAlignment = .center
        label.numberOfLines = 0
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var logoutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(" Logout ", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = FontFamily.RobotoMono.medium.font(size: 14)
        btn.backgroundColor = .systemGray6
        btn.layer.cornerRadius = 6
        btn.addTarget(self, action: #selector(onLogout), for: .touchUpInside)
        self.containerView.addSubview(btn)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

        self.dismissView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.containerView.snp.top)
        }
        
        self.containerView.snp.makeConstraints { make in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.closeBtn.snp.centerY)
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualTo(self.closeBtn.snp.left).offset(16)
        }
        
        self.closeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.closeBtn.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(16)
        }
        
        self.logoutBtn.snp.makeConstraints { make in
            make.top.equalTo(self.infoLabel.snp.bottom).offset(32)
            make.bottom.equalToSuperview().offset(-48)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func onClose() {
        self.dismiss()
    }
    
    @objc private func onLogout() {
        self.service.logout()
        self.dismiss {
            self.navigationProvider.tabBarDelegate.updateLoginState()
        }
    }
}
