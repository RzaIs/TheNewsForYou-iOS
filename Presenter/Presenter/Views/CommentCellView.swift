//
//  CommentCellView.swift
//  Presenter
//
//  Created by Rza Ismayilov on 19.09.22.
//

import UIKit
import SnapKit
import SkeletonView
import Domain

class CommentCellView: UITableViewCell {
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = FontFamily.RobotoMono.regular.font(size: 10)
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = FontFamily.RobotoMono.regular.font(size: 10)
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.RobotoMono.regular.font(size: 12)
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
        
        self.authorLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(self.authorLabel.snp.centerY)
        }
        
        self.contentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.authorLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func setData(_ comment: CommentEntity) {
        self.authorLabel.text = comment.author.email
        self.contentLabel.text = comment.content
        self.dateLabel.text = comment.publishDate
    }
    
    func setAsSkeleton() {
        self.authorLabel.backgroundColor = .systemGray6
        self.authorLabel.layer.cornerRadius = 4
        self.authorLabel.clipsToBounds = true
        self.contentLabel.backgroundColor = .systemGray6
        self.contentLabel.layer.cornerRadius = 4
        self.contentLabel.clipsToBounds = true
        self.authorLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        self.contentLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }
}
