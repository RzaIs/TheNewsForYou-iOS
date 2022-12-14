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
        
    private weak var delegate: NewsCellDelegate?
    
    private var mutex: Bool = false
    private var newsID: String = ""
    private var newsURL: String = ""
    private var numberOfLikes: Int = 0 {
        didSet {
            self.likeBtn.setTitle("  \(self.numberOfLikes)", for: .normal)
        }
    }
    private var status: NewsCellLikeStatus = .notLikedYet {
        didSet {
            switch self.status {
            case .alreadyLiked:
                self.likeBtn.setImage(self.likedImage, for: .normal)
            case .notLikedYet:
                self.likeBtn.setImage(self.notLikedImage, for: .normal)
            }
        }
    }
    
    private let likedImage: UIImage? = .init(systemName:  "hand.thumbsup.fill")?
        .withTintColor(.black, renderingMode: .alwaysOriginal)
    private let notLikedImage: UIImage? = .init(systemName:  "hand.thumbsup")?
        .withTintColor(.black, renderingMode: .alwaysOriginal)
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MM-dd-YYYY HH:mm")
        return formatter
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .systemGray6
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
    
    private lazy var actionStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        self.containerView.addSubview(view)
        return view
    }()
    
    private lazy var likeBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onLike), for: .touchUpInside)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("   ", for: .normal)
        btn.setImage(
            UIImage(systemName: "hand.thumbsup")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        self.containerView.addSubview(btn)
        return btn
    }()
    
    private lazy var commentBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onComment), for: .touchUpInside)
        btn.setImage(
            UIImage(systemName: "text.bubble")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        self.containerView.addSubview(btn)
        return btn
    }()
    
    private lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onShare), for: .touchUpInside)
        btn.setImage(
            UIImage(systemName: "square.on.square")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        self.containerView.addSubview(btn)
        return btn
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
        
        self.actionStack.addArrangedSubview(self.likeBtn)
        self.actionStack.addArrangedSubview(self.commentBtn)
        self.actionStack.addArrangedSubview(self.shareBtn)
        
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
            make.bottom.lessThanOrEqualTo(self.actionStack.snp.top).offset(-12)
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
            make.top.greaterThanOrEqualTo(self.descriptionLabel.snp.bottom).offset(12)
            make.left.equalTo(self.descriptionLabel.snp.left)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalTo(self.actionStack.snp.top).offset(-12)
        }
        
        self.actionStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.likeBtn.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(96)
        }
        
        self.commentBtn.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(96)
        }
        
        self.shareBtn.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(96)
        }
    }
    
    func setAsSkeleton() {
        self.containerView.showAnimatedSkeleton()
    }
    
    func setDelegate(_ delegate: NewsCellDelegate) {
        self.delegate = delegate
        self.initState()
    }
    
    func initState() {
        mutex = false
        Task {
            guard let likes = await self.delegate?.getLikes(newsID: self.newsID)
            else { return }
            self.numberOfLikes = likes.count
            if let owned = likes.first(where: { $0.isAdmin }) {
                self.status = .alreadyLiked(owned)
            } else {
                self.status = .notLikedYet
            }
            self.mutex = true
        }
    }
    
    func setData(_ searchArticle: SearchArticleEntity, hasImage: Bool) {
        self.newsURL = searchArticle.url?.absoluteString ?? ""
        self.newsID = searchArticle.id
        self.sectionLabel.text = searchArticle.sectionName
        self.subsectionLabel.text = searchArticle.subsectionName
        self.titleLabel.text = searchArticle.title
        self.authorLabel.text = searchArticle.author
        self.descriptionLabel.text = searchArticle.abstract
        switch searchArticle.publishDate {
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
        if let safeURL = searchArticle.multimedia.last {
            self.previewImg.kf.setImage(with: safeURL)
        }
    }
    
    func setData(_ mostPopular: MostPopularEntity, hasImage: Bool) {
        self.newsURL = mostPopular.url?.absoluteString ?? ""
        self.newsID = mostPopular.id.description
        self.sectionLabel.text = mostPopular.section
        self.subsectionLabel.text = mostPopular.subsection
        self.titleLabel.text = mostPopular.title
        self.authorLabel.text = mostPopular.author
        self.descriptionLabel.text = mostPopular.abstract
        switch mostPopular.publishDate {
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
        if let safeURL = mostPopular.media.last {
            self.previewImg.kf.setImage(with: safeURL)
        }
    }
    
    func setData(_ topStory: TopStoryEntity, hasImage: Bool) {
        self.newsURL = topStory.url?.absoluteString ?? ""
        self.newsID = topStory.id
        self.sectionLabel.text = topStory.section
        self.subsectionLabel.text = topStory.subsection
        self.titleLabel.text = topStory.title
        self.authorLabel.text = topStory.author
        self.descriptionLabel.text = topStory.abstract
        switch topStory.publishDate {
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
        if let safeURL = topStory.multimedia.last {
            self.previewImg.kf.setImage(with: safeURL)
        }
    }
    
    private func reloadTable() {
        guard let tableView = self.superview as? UITableView else { return }
        tableView.reloadData()
    }
    
    @objc private func onLike() {
        guard let delegate = self.delegate else { return }
        guard delegate.isLoggedIn else {
            delegate.showWelcomeVC()
            return
        }
        guard mutex else { return }
        mutex = false
        switch self.status {
        case .notLikedYet:
            Task {
                await self.delegate?.submitLike(newsID: self.newsID)
                self.initState()
            }
        case .alreadyLiked(let like):
            Task {
                await self.delegate?.deleteLike(id: like.id)
                self.initState()
            }
        }
    }
    
    @objc private func onComment() {
        guard let delegate = self.delegate else { return }
        if delegate.isLoggedIn {
            delegate.showCommentVC(newsID: self.newsID)
        } else {
            delegate.showWelcomeVC()
        }
    }
    
    @objc private func onShare() {
        UIPasteboard.general.string = self.newsURL
        self.delegate?.showToast(message: "copied to clipboard")
    }
}

enum NewsCellLikeStatus {
    case notLikedYet
    case alreadyLiked(LikeEntity)
}

protocol NewsCellDelegate: AnyObject {
    func showToast(message: String)
    func showCommentVC(newsID: String)
    func showWelcomeVC()
    func getLikes(newsID: String) async -> [LikeEntity]?
    func submitLike(newsID: String) async
    func deleteLike(id: String) async
    var isLoggedIn: Bool { get }
}
