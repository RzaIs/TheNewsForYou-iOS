//
//  MostPopularRepoProtocol.swift
//  Domain
//
//  Created by Rza Ismayilov on 11.09.22.
//

import Combine

public protocol MostPopularRepoProtocol {
    func syncMostPopular() async throws
    func deleteMostPopular() throws
    var observeMostPopular: AnyPublisher<[MostPopularEntity], Never> { get }
}
