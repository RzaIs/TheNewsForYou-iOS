//
//  CommentVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 19.09.22.
//

import UIKit
import SnapKit
import SkeletonView

class CommentVC: BaseVC<Void, CommentEffect, CommentService> {
    
    private let commentCell: String = "COMMENT_CELL"
    private let commentCellSkeleton: String = "COMMENT_CELL_SKELETON"

    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return rc
    }()
    
    private lazy var commentsTable: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(CommentCellView.self, forCellReuseIdentifier: self.commentCell)
        view.register(CommentCellView.self, forCellReuseIdentifier: self.commentCellSkeleton)
        view.addSubview(refreshControl)
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var commentInputView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 21
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var commentField: UITextField = {
        let field = UITextField()
        field.font = FontFamily.RobotoMono.regular.font(size: 18)
        self.commentInputView.addSubview(field)
        return field
    }()
    
    private lazy var submitBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("POST", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        self.commentInputView.addSubview(btn)
        return btn
    }()
    
    private lazy var dismissKeyboardBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onDismissKeyboard), for: .touchUpInside)
        btn.setImage(
            UIImage(systemName: "keyboard.chevron.compact.down")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        btn.imageView?.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(32)
        }
        btn.backgroundColor = .systemGray3
        btn.layer.cornerRadius = 21
        btn.clipsToBounds = true
        btn.isHidden = true
        self.view.addSubview(btn)
        return btn
    }()
    
    private lazy var emptyCommentView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerKeyboardNotification()
        self.title = "Comments"
        
        self.commentsTable.snp.makeConstraints { make in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).offset(6)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-6)
        }
        
        
        self.submitBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(52)
        }
        
        self.commentField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(self.submitBtn.snp.left).offset(-12)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        self.commentInputView.snp.makeConstraints { make in
            make.top.equalTo(self.commentsTable.snp.bottom).offset(6)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(6)
            make.bottom.right.equalTo(self.view.safeAreaLayoutGuide).offset(-6)
            make.height.equalTo(42)
        }
        
        self.dismissKeyboardBtn.snp.makeConstraints { make in
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-6)
            make.bottom.equalTo(self.commentInputView.snp.top).offset(-6)
            make.height.width.equalTo(42)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            self.service.showSkeleton = true
            await self.service.syncComments()
            self.service.showSkeleton = false
        }
    }
    
    override func observe(effect: CommentEffect) {
        switch effect {
        case .dismissKeyboard:
            self.commentField.endEditing(true)
        case .reloadTable:
            self.commentsTable.reloadData()
        }
    }
    
    override func keyboardAppeared(offset: CGFloat) {
        super.keyboardAppeared(offset: offset)
        self.dismissKeyboardBtn.isHidden = false
        self.commentInputView.snp.updateConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(offset - 6)
        }
        
    }
    
    override func keyboardDisappeared() {
        super.keyboardDisappeared()
        self.dismissKeyboardBtn.isHidden = true
        self.commentInputView.snp.updateConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-6)
        }
    }
    
    func copyComment(index: Int) {
        UIPasteboard.general.string = self.service.comments[index].content
        self.showToast(message: "copied to clipboard")
    }
    
    func deleteComment(index: Int) {
        let commentID = self.service.comments[index].id
        Task {
            await self.service.deleteComment(id: commentID)
        }
    }
    
    @objc private func onSubmit() {
        guard let content = self.commentField.text, !content.isEmpty else { return }
        Task {
            await self.service.submitComment(content: content)
            self.commentField.text = ""
        }
    }
    
    @objc private func onRefresh() {
        Task {
            await self.service.syncComments()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc private func onDismissKeyboard() {
        self.commentField.endEditing(true)
    }
}

extension CommentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            self?.deleteComment(index: indexPath.row)
            completion(true)
        }
        deleteAction.backgroundColor = .red
        
        let copyAction = UIContextualAction(style: .normal, title: "Copy") { [weak self] action, view, completion in
            self?.copyComment(index: indexPath.row)
            completion(true)
        }
        copyAction.backgroundColor = .blue
        
        if self.service.comments.count == 0 {
            return UISwipeActionsConfiguration(actions: [])
        }
        if self.service.comments[indexPath.row].isAdmin {
            return UISwipeActionsConfiguration(actions: [copyAction, deleteAction])
        } else {
            return UISwipeActionsConfiguration(actions: [copyAction])
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let size = self.service.comments.count
        if size == 0, self.service.showSkeleton {
            return 7
        } else {
            return size
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCellView
        if self.service.comments.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: self.commentCellSkeleton, for: indexPath) as! CommentCellView
            cell.setAsSkeleton()
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: self.commentCell, for: indexPath) as! CommentCellView
            cell.setData(self.service.comments[indexPath.row])
        }
        return cell
    }
}
