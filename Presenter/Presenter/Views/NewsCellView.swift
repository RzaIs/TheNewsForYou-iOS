//
//  NewsCellView.swift
//  Presenter
//
//  Created by Rza Ismayilov on 17.09.22.
//

import UIKit
import SnapKit
import SkeletonView
import Kingfisher
import Domain

class NewsCellView: UITableViewCell {
        
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MM-dd-YYYY HH:mm")
        return formatter
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .systemGray5
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.RobotoMono.regular.font(size: 14)
        label.backgroundColor = .blue
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        label.textColor = .white
        label.textAlignment = .center
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var subsectionLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.RobotoMono.regular.font(size: 14)
        label.backgroundColor = .magenta
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        label.textColor = .white
        label.textAlignment = .center
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var previewImg: UIImageView = {
        let view = UIImageView()
        self.containerView.addSubview(view)
        return view
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.RobotoMono.light.font(size: 10)
        label.numberOfLines = 0
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FontFamily.RobotoMono.bold.font(size: 16)
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FontFamily.RobotoMono.regular.font(size: 14)
        self.containerView.addSubview(label)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.RobotoMono.light.font(size: 10)
        label.textAlignment = .right
        self.containerView.addSubview(label)
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
        
        self.containerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(6)
            make.right.bottom.equalToSuperview().offset(-6)
        }
        
        self.sectionLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.right.equalTo(self.previewImg.snp.right)
        }
        
        self.subsectionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.sectionLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(self.previewImg.snp.right)
        }
        
        self.previewImg.snp.makeConstraints { make in
            make.top.equalTo(self.subsectionLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(100)
        }
        
        self.authorLabel.snp.makeConstraints { make in
            make.top.equalTo(self.previewImg.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(self.previewImg.snp.right)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(self.previewImg.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self.previewImg.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(12)
            make.left.equalTo(self.descriptionLabel.snp.left)
            make.right.equalToSuperview().offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
    }
    
    func setAsSkeleton() {
        self.containerView.showAnimatedSkeleton()
    }
    
    
    
    func setData(_ data: MostPopularEntity, hasImage: Bool) {
        self.sectionLabel.text = data.section
        self.subsectionLabel.text = data.subsection
        self.titleLabel.text = data.title
        self.authorLabel.text = data.author
        self.descriptionLabel.text = data.abstract
        switch data.publishDate {
        case .at(let date):
            self.dateLabel.text = self.dateFormatter.string(from: date)
        case .unknown:
            self.dateLabel.text = ""
        }
        
        if hasImage {
            self.previewImg.snp.updateConstraints { make in
                make.height.equalTo(100)
            }
        } else {
            self.previewImg.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        
        self.previewImg.image = nil
        if let safeURL = data.media.last {
            self.previewImg.kf.setImage(with: safeURL)
        }
    }
    
    func setData(_ data: TopStoryEntity, hasImage: Bool) {
        
        self.sectionLabel.text = data.section
        self.subsectionLabel.text = data.subsection
        self.titleLabel.text = data.title
        self.authorLabel.text = data.author
        self.descriptionLabel.text = data.abstract
        switch data.publishDate {
        case .at(let date):
            self.dateLabel.text = self.dateFormatter.string(from: date)
        case .unknown:
            self.dateLabel.text = ""
        }
        
        if hasImage {
            self.previewImg.snp.updateConstraints { make in
                make.height.equalTo(100)
            }
        } else {
            self.previewImg.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        
        self.previewImg.image = nil
        if let safeURL = data.multimedia.last {
            self.previewImg.kf.setImage(with: safeURL)
        }
    }
}

enum CellType {
    case topStory(TopStoryEntity)
    case mostPopular(MostPopularEntity)
}
