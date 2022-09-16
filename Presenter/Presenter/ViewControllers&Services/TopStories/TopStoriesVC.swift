//
//  TopStoriesVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 31.08.22.
//

import UIKit
import SnapKit
import SafariServices

class TopStoriesVC: BaseVC<Void, TopStoriesEffect, TopStoriesService> {
    
    private let SafariConfig: SFSafariViewController.Configuration = {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        return config
    }()
    
    private let topStoryCellHasImg: String = "STORY_CELL_HAS_IMG"
    private let topStoryCellNoImg: String = "STORY_CELL_NO_IMG"
    private let topStoryCellSkeleton: String = "STORY_CELL_SKELETON"
    
    private lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: self.service.segmentNames)
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(onSegmentSelect(_:)), for: .valueChanged)
        self.view.addSubview(sc)
        return sc
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return rc
    }()
    
    private lazy var storiesTable: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(TopStoryCell.self, forCellReuseIdentifier: self.topStoryCellHasImg)
        view.register(TopStoryCell.self, forCellReuseIdentifier: self.topStoryCellNoImg)
        view.register(TopStoryCell.self, forCellReuseIdentifier: self.topStoryCellSkeleton)
        view.addSubview(self.refreshControl)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
        }
        
        self.storiesTable.snp.makeConstraints { make in
            make.top.equalTo(self.segmentControl.snp.bottom).offset(16)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(6)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-6)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await self.service.syncTopStories()
        }
        
        let storiesCancellable = self.service.observeTopStories
            .sink { topStories in
                self.service.topStories = topStories.filter { story in
                    story.segment == self.service.storySegment
                }
            }
        
        self.add(cancellable: storiesCancellable)
    }
    
    override func observe(effect: TopStoriesEffect) {
        super.observe(effect: effect)
        
        switch effect {
        case .reloadTable:
            self.storiesTable.reloadData()
        }
    }
    
    @objc private func onRefresh() {
        Task {
            await self.service.syncTopStories()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc private func onSegmentSelect(_ sender: UISegmentedControl) {
        if self.service.topStories.count > 0 {
            self.storiesTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        let segmentIndex = sender.selectedSegmentIndex
        Task {
            await self.service.selectedSegment(index: segmentIndex)
        }
    }
}

extension TopStoriesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = self.service.topStories[indexPath.row].url {
            let vc = SFSafariViewController(url: url, configuration: self.SafariConfig)
            self.presentVC(vc)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let size = self.service.topStories.count
        if size == 0, self.service.showSkeleton {
            return 5
        } else {
            return size
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TopStoryCell
        
        if self.service.topStories.count ==  0 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.topStoryCellSkeleton, for: indexPath) as! TopStoryCell
            cell.setAsSkeleton()
        } else if self.service.topStories[indexPath.row].multimedia.isEmpty {
            cell = tableView.dequeueReusableCell(withIdentifier: self.topStoryCellNoImg, for: indexPath) as! TopStoryCell
            cell.setData(self.service.topStories[indexPath.row], hasImage: false)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: self.topStoryCellHasImg, for: indexPath) as! TopStoryCell
            cell.setData(self.service.topStories[indexPath.row], hasImage: true)
        }
        return cell
    }
}
