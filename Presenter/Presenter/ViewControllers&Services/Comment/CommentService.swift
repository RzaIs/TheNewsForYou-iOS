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
    private let deleteCommentsUseCase: BaseAsyncThrowsUseCase<String, Void>
    private let submitCommentsUseCase: BaseAsyncThrowsUseCase<CommentInput, Void>
    
    init(newsID: String,
         getCommentsUseCase: BaseAsyncThrowsUseCase<String, [CommentEntity]>,
         deleteCommentsUseCase: BaseAsyncThrowsUseCase<String, Void>,
         submitCommentsUseCase: BaseAsyncThrowsUseCase<CommentInput, Void>
    ) {
        self.newsID = newsID
        self.getCommentsUseCase = getCommentsUseCase
        self.deleteCommentsUseCase = deleteCommentsUseCase
        self.submitCommentsUseCase = submitCommentsUseCase
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
            try await self.deleteCommentsUseCase.execute(input: id)
            sleep(1)
            await self.syncComments()
        } catch {
            self.show(error: error)
        }
    }
    
    func submitComment(content: String) async {
        do {
            try await self.submitCommentsUseCase.execute(
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
