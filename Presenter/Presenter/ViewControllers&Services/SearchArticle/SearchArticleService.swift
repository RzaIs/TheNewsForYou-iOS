//
//  SearchArticleService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 18.09.22.
//

import Combine
import Domain

class SearchArticleService: BaseService<Void, SearchArticleEffect> {
    
    var query: String = ""
    var articles: [SearchArticleEntity] = []
    var showSkeleton: Bool = false {
        didSet {
            self.post(effect: .reloadTable)
        }
    }
    
    private let searchSubject: PassthroughSubject<String, Never> = .init()
    private let searchArticleUseCase: BaseAsyncThrowsUseCase<String, [SearchArticleEntity]>
    private let authIsLoggedInUseCase: BaseUseCase<Void, Bool>

    init(searchArticleUseCase: BaseAsyncThrowsUseCase<String, [SearchArticleEntity]>,
         authIsLoggedInUseCase: BaseUseCase<Void, Bool>
    ) {
        self.searchArticleUseCase = searchArticleUseCase
        self.authIsLoggedInUseCase = authIsLoggedInUseCase
    }
    
    func queryEntered(query: String) {
        self.query = query
        self.searchSubject.send(query)
    }
    
    func observeQuery() -> AnyPublisher<String, Never> {
        self.searchSubject.debounce(for: .seconds(0.6), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func refreshArticles() async {
        self.articles = []
        self.showSkeleton = true
        do {
            if !self.query.isEmpty {
                self.articles = try await self.searchArticleUseCase.execute(input: self.query)
            }
        } catch {
            self.show(error: error)
        }
        self.showSkeleton = false
    }
    
    func searchArticles(query: String) async {
        self.articles = []
        self.showSkeleton = true
        do {
            if !query.isEmpty {
                self.articles = try await self.searchArticleUseCase.execute(input: query)
            }
        } catch {
            self.show(error: error)
        }
        self.showSkeleton = false
    }
    
    var isLoggedIn: Bool {
        self.authIsLoggedInUseCase.execute(input: Void())
    }
}

enum SearchArticleEffect {
    case reloadTable
}
