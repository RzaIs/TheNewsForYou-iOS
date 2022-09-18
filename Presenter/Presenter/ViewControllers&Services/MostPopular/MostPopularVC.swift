//
//  MostPopularVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 11.09.22.
//

import UIKit
import SnapKit
import SafariServices

class MostPopularVC: BaseVC<Void, MostPopularEffect, MostPopularService> {
    
    private let SafariConfig: SFSafariViewController.Configuration = {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        return config
    }()
    
    private let mostPopularCellWithImage: String = "MOST_POPULAR_CELL_WITH_IMAGE"
    private let mostPopularCellWithNoImg: String = "MOST_POPULAR_CELL_WITH_NO_IMG"
    private let mostPopularCellSkeleton: String = "MOST_POPULAR_CELL_SKELETON"

    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return rc
    }()
    
    private lazy var mostPopularTable: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(NewsCellView.self, forCellReuseIdentifier: self.mostPopularCellWithImage)
        view.register(NewsCellView.self, forCellReuseIdentifier: self.mostPopularCellWithNoImg)
        view.register(NewsCellView.self, forCellReuseIdentifier: self.mostPopularCellSkeleton)
        view.addSubview(self.refreshControl)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mostPopularTable.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(6)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(6)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-6)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await self.service.syncMostPopular()
        }
        
        let storiesCancellable = self.service.observeMostPopular
            .sink { mostPopular in
                self.service.mostPopular = mostPopular
            }

        self.add(cancellable: storiesCancellable)
    }
    
    override func observe(effect: MostPopularEffect) {
        super.observe(effect: effect)
        
        switch effect {
        case .reloadTable:
            self.mostPopularTable.reloadData()
        }
    }
    
    @objc private func onRefresh() {
        Task {
            await self.service.syncMostPopular()
            self.refreshControl.endRefreshing()
        }
    }
}

extension MostPopularVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = self.service.mostPopular[indexPath.row].url {
            let vc = SFSafariViewController(url: url, configuration: self.SafariConfig)
            self.presentVC(vc)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let size = self.service.mostPopular.count
        if size == 0, self.service.showSkeleton {
            return 5
        } else {
            return size
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsCellView
        
        if self.service.mostPopular.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.mostPopularCellSkeleton, for: indexPath) as! NewsCellView
            cell.setAsSkeleton()
        } else if self.service.mostPopular[indexPath.row].media.isEmpty {
            cell = tableView.dequeueReusableCell(withIdentifier: self.mostPopularCellWithImage, for: indexPath) as! NewsCellView
            cell.setData(self.service.mostPopular[indexPath.row], hasImage: false)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: self.mostPopularCellWithImage, for: indexPath) as! NewsCellView
            cell.setData(self.service.mostPopular[indexPath.row], hasImage: true)
        }
        return cell
    }
}
