//
//  TopStoriesService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 31.08.22.
//

import Domain
import Combine

class TopStoriesService: BaseService<Void, TopStoriesEffect> {
    
    let segmentNames = ["Home", "Arts", "Science", "World"]
    
    var showSkeleton: Bool = true {
        didSet {
            self.post(effect: .reloadTable)
        }
    }
    var storySegment: TopStorySegmentEntity = .home {
        didSet {
            self.showSkeleton = true
        }
    }
    var topStories: [TopStoryEntity] = [] {
        didSet {
            self.post(effect: .reloadTable)
        }
    }
    
    private let syncTopStoriesUseCase: BaseAsyncThrowsUseCase<TopStoriesInput, Void>
    private let getTopStoriesUseCase: BaseUseCase<TopStoriesInput, [TopStoryEntity]>
    private let observeTopStoriesUseCase: BaseObserveUseCase<Void, [TopStoryEntity]>
    private let authIsLoggedInUseCase: BaseUseCase<Void, Bool>
    
    init(syncTopStoriesUseCase: BaseAsyncThrowsUseCase<TopStoriesInput, Void>,
         getTopStoriesUseCase: BaseUseCase<TopStoriesInput, [TopStoryEntity]>,
         observeTopStoriesUseCase: BaseObserveUseCase<Void, [TopStoryEntity]>,
         authIsLoggedInUseCase: BaseUseCase<Void, Bool>
    ) {
        self.syncTopStoriesUseCase = syncTopStoriesUseCase
        self.getTopStoriesUseCase = getTopStoriesUseCase
        self.observeTopStoriesUseCase = observeTopStoriesUseCase
        self.authIsLoggedInUseCase = authIsLoggedInUseCase
    }
    
    func syncTopStories() async {
        do {
            try await self.syncTopStoriesUseCase.execute(input: self.storySegment.toInput)
        } catch {
            self.show(error: error)
        }
        self.showSkeleton = false
    }
    
    var observeTopStories: AnyPublisher<[TopStoryEntity], Never> {
        self.observeTopStoriesUseCase.observe(input: Void())
    }

    var isLoggedIn: Bool {
        self.authIsLoggedInUseCase.execute(input: Void())
    }
    
    func selectedSegment(index: Int) async {
        guard let segmentName = self.segmentNames.safe[index]?.lowercased(),
              let segment = TopStorySegmentEntity(rawValue: segmentName)
        else { return }
        
        self.topStories = self.getTopStoriesUseCase.execute(input: segment.toInput)
        
        self.storySegment = segment
        await self.syncTopStories()
    }
}


enum TopStoriesEffect {
    case reloadTable
}
