//
//  DomainAssembly.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Swinject

public class DomainAssembly: Assembly {
    
    public init() { }
    
    public func assemble(container: Container) {
        container.register(AuthLoginUseCase.self) { r in
            AuthLoginUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthRegisterUseCase.self) { r in
            AuthRegisterUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthIsLoggedInUseCase.self) { r in
            AuthIsLoggedInUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthLogoutUseCase.self) { r in
            AuthLogoutUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthGetFirstOpeningDateUseCase.self) { r in
            AuthGetFirstOpeningDateUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthSetFirstOpeningDateUseCase.self) { r in
            AuthSetFirstOpeningDateUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthGetUserEmailUseCase.self) { r in
            AuthGetUserEmailUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(SyncTopStoriesUseCase.self) { r in
            SyncTopStoriesUseCase(repo: r.resolve(TopStoriesRepoProtocol.self)!)
        }
        
        container.register(ObserveTopStoriesUseCase.self) { r in
            ObserveTopStoriesUseCase(repo: r.resolve(TopStoriesRepoProtocol.self)!)
        }
        
        container.register(GetTopStoriesUseCase.self) { r in
            GetTopStoriesUseCase(repo: r.resolve(TopStoriesRepoProtocol.self)!)
        }
        
        container.register(SyncMostPopularUseCase.self) { r in
            SyncMostPopularUseCase(repo: r.resolve(MostPopularRepoProtocol.self)!)
        }
        
        container.register(ObserveMostPopularUseCase.self) { r in
            ObserveMostPopularUseCase(repo: r.resolve(MostPopularRepoProtocol.self)!)
        }
        
        container.register(GetCommentsUseCase.self) { r in
            GetCommentsUseCase(repo: r.resolve(CommentRepoProtocol.self)!)
        }
        
        container.register(DeleteCommentUseCase.self) { r in
            DeleteCommentUseCase(repo: r.resolve(CommentRepoProtocol.self)!)
        }
        
        container.register(SubmitCommentUseCase.self) { r in
            SubmitCommentUseCase(repo: r.resolve(CommentRepoProtocol.self)!)
        }
        
        container.register(GetLikesUseCase.self) { r in
            GetLikesUseCase(repo: r.resolve(LikeRepoProtocol.self)!)
        }
        
        container.register(SubmitLikeUseCase.self) { r in
            SubmitLikeUseCase(repo: r.resolve(LikeRepoProtocol.self)!)
        }
        
        container.register(DeleteLikeUseCase.self) { r in
            DeleteLikeUseCase(repo: r.resolve(LikeRepoProtocol.self)!)
        }
        
        container.register(SearchArticleUseCase.self) { r in
            SearchArticleUseCase(repo: r.resolve(SearchArticleRepoProtocol.self)!)
        }
    }
}
