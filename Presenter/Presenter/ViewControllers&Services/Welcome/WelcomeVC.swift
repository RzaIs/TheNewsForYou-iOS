//
//  WelcomeVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 29.08.22.
//

import UIKit
import SnapKit

class WelcomeVC: BaseVC<Void, Void, WelcomeService> {
    
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
            UITapGestureRecognizer(target: self, action: #selector(onSkip))
        )
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to\nTHE NEWS FOR YOU!"
        label.numberOfLines = 0
        label.font = FontFamily.RobotoMono.bold.font(size: 24)
        label.textAlignment = .center
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Login or Register to enable comments and likes."
        label.numberOfLines = 0
        label.font = FontFamily.RobotoMono.regular.font(size: 20)
        label.textAlignment = .center
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = FontFamily.RobotoMono.bold.font(size: 24)
        btn.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        self.containerView.addSubview(btn)
        return btn
    }()
    
    private lazy var laterBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Later", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGray
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = FontFamily.RobotoMono.bold.font(size: 24)
        btn.addTarget(self, action: #selector(onSkip), for: .touchUpInside)
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
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.descriptionLabel.snp.top).offset(-13)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-32)
        }
        
        self.nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.laterBtn.snp.top).offset(-32)
            make.width.equalTo(200)
        }
        
        self.laterBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-64)
            make.width.equalTo(200)
        }
    }
    
    @objc private func onSkip() {
        self.dismiss()
    }
    
    @objc private func onNext() {
        self.dismiss { [weak self] in
            guard let authVC = self?.navigationProvider.authVC else { return }
            self?.pushVC(authVC)
        }
    }
}
