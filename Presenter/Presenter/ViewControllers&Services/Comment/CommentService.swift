//
//  CommentService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 19.09.22.
//

import Domain

class CommentService: BaseService<Void, CommentEffect> {
    
    var comments: [CommentEntity] = []
    var showSkeleton: Bool = true {
        didSet {
            self.post(effect: .reloadTable)
        }
    }
    
    private let newsID: String
    private let getCommentsUseCase: BaseAsyncThrowsUseCase<String, [CommentEntity]>
    private let deleteCommentUseCase: BaseAsyncThrowsUseCase<String, Void>
    private let submitCommentUseCase: BaseAsyncThrowsUseCase<CommentInput, Void>
    
    init(newsID: String,
         getCommentsUseCase: BaseAsyncThrowsUseCase<String, [CommentEntity]>,
         deleteCommentUseCase: BaseAsyncThrowsUseCase<String, Void>,
         submitCommentUseCase: BaseAsyncThrowsUseCase<CommentInput, Void>
    ) {
        self.newsID = newsID
        self.getCommentsUseCase = getCommentsUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        self.submitCommentUseCase = submitCommentUseCase
    }

    func syncComments() async {
        do {
            self.comments = try await self.getCommentsUseCase.execute(input: self.newsID)
            self.post(effect: .reloadTable)
        } catch {
            self.show(error: error)
        }
    }
    
    func deleteComment(id: String) async {
        do {
            try await self.deleteCommentUseCase.execute(input: id)
            usleep(100000)
            await self.syncComments()
        } catch {
            self.show(error: error)
        }
    }
    
    func submitComment(content: String) async {
        do {
            try await self.submitCommentUseCase.execute(
                input: CommentInput(content: content, newsID: self.newsID)
            )
            self.post(effect: .dismissKeyboard)
            await self.syncComments()
        } catch {
            self.show(error: error)
        }
    }
}

enum CommentEffect {
    case dismissKeyboard
    case reloadTable
}
