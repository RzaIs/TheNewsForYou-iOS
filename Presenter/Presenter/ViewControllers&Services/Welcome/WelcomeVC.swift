//
//  WelcomeVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 29.08.22.
//

import UIKit
import SnapKit

class WelcomeVC: BaseVC<Void, Void, WelcomeService> {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to THE NEWS FOR YOU!"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onNext(_:)))
        )
        self.view.addSubview(btn)
        return btn
    }()
    
    private lazy var laterBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Later", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .gray
        btn.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onSkip(_:)))
        )
        self.view.addSubview(btn)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        self.nextBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            make.bottom.equalTo(self.laterBtn.snp.top).offset(-36)
            make.width.equalTo(200)
        }
        
        self.laterBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-36)
            make.width.equalTo(200)
        }
    }
    
    @objc private func onSkip(_ sender: UITapGestureRecognizer) {
        self.dismiss()
    }
    
    @objc private func onNext(_ sender: UITapGestureRecognizer) {
        self.dismiss { [weak self] in
            guard let authVC = self?.navigationProvider.authVC else { return }
            self?.pushVC(authVC)
        }
    }
}
