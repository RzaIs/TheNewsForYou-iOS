//
//  TopStoriesRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 31.08.22.
//

protocol TopStoriesRemoteDataSourceProtocol {
    func getTopStories(segment: String) async throws -> BaseRemoteDTO<TopStoryRemoteDTO>
}
