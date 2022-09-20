//
//  SearchArticleVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 18.09.22.
//

import UIKit
import SnapKit
import SafariServices
import SkeletonView
import Domain

class SearchArticleVC: PageVC<Void, SearchArticleEffect, SearchArticleService> {
    
    private let safariConfig: SFSafariViewController.Configuration = {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        return config
    }()
    
    private let searchArticleCellWithImage: String = "SEARCH_ARTICLE_CELL_WITH_IMAGE"
    private let searchArticleCellWithNoImg: String = "SEARCH_ARTICLE_CELL_WITH_NO_IMG"
    private let searchArticleCellSkeleton: String = "SEARCH_ARTICLE_CELL_SKELETON"

    private lazy var searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 21
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        self.searchView.addSubview(view)
        return view
    }()
    
    private lazy var searchField: UITextField = {
        let field = UITextField()
        field.font = FontFamily.RobotoMono.regular.font(size: 18)
        field.addTarget(self, action: #selector(onSearchFieldChange), for: .editingChanged)
        self.searchView.addSubview(field)
        return field
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return rc
    }()
    
    private lazy var articlesTable: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(NewsCellView.self, forCellReuseIdentifier: self.searchArticleCellWithImage)
        view.register(NewsCellView.self, forCellReuseIdentifier: self.searchArticleCellWithNoImg)
        view.register(NewsCellView.self, forCellReuseIdentifier: self.searchArticleCellSkeleton)
        view.addSubview(self.refreshControl)
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var keyboardCloseBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onKeyboardClose), for: .touchUpInside)
        btn.setImage(
            UIImage(systemName: "keyboard.chevron.compact.down")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        btn.imageView?.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(32)
        }
        btn.backgroundColor = .systemGray3
        btn.layer.cornerRadius = 28
        btn.clipsToBounds = true
        btn.isHidden = true
        self.view.addSubview(btn)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerKeyboardNotification()
        
        self.searchView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(6)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.height.equalTo(42)
        }
        
        self.searchIcon.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.width.height.equalTo(30)
        }
        
        self.searchField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.equalTo(self.searchIcon.snp.right).offset(6)
            make.right.bottom.equalToSuperview().offset(-6)
        }
        
        self.articlesTable.snp.makeConstraints { make in
            make.top.equalTo(self.searchField.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(6)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-6)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    override func observe(effect: SearchArticleEffect) {
        switch effect {
        case .reloadTable:
            self.articlesTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let queryCancellable = self.service.observeQuery().sink { query in
            Task {
                await self.service.searchArticles(query: query)
            }
        }
        
        self.add(cancellable: queryCancellable)
    }
    
    override func keyboardAppeared(offset: CGFloat) {
        super.keyboardAppeared(offset: offset)
        self.articlesTable.snp.updateConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(offset + 72)
        }
        self.keyboardCloseBtn.isHidden = false
        self.keyboardCloseBtn.snp.makeConstraints { make in
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-18)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(offset + 64)
            make.height.width.equalTo(56)
        }
    }
    
    override func keyboardDisappeared() {
        super.keyboardDisappeared()
        self.keyboardCloseBtn.isHidden = true
        self.articlesTable.snp.updateConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    @objc private func onKeyboardClose() {
        self.searchField.endEditing(true)
    }
    
    @objc private func onSearchFieldChange() {
        if let query = self.searchField.text {
            self.service.queryEntered(query: query)
        }
    }
    
    @objc private func onRefresh() {
        Task {
            await self.service.refreshArticles()
            self.refreshControl.endRefreshing()
        }
    }
}

extension SearchArticleVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = self.service.articles.safe[indexPath.row]?.url {
            let vc = SFSafariViewController(url: url, configuration: self.safariConfig)
            self.presentVC(vc)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let size = self.service.articles.count
        if size == 0, self.service.showSkeleton {
            return 5
        } else {
            return size
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsCellView
        if self.service.articles.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.searchArticleCellSkeleton, for: indexPath) as! NewsCellView
            cell.setAsSkeleton()
        } else if self.service.articles[indexPath.row].multimedia.isEmpty {
            cell = tableView.dequeueReusableCell(withIdentifier: self.searchArticleCellWithNoImg, for: indexPath) as! NewsCellView
            cell.setData(self.service.articles[indexPath.row], hasImage: false)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: self.searchArticleCellWithImage, for: indexPath) as! NewsCellView
            cell.setData(self.service.articles[indexPath.row], hasImage: true)
        }
        cell.setDelegate(self)
        return cell
    }
}
