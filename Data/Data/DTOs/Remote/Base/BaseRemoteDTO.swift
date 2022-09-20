//
//  BaseRemoteDTO.swift
//  Data
//
//  Created by Rza Ismayilov on 31.08.22.
//

class BaseRemoteDTO<T: Decodable>: Decodable {
    let results: [T]
    init(results: [T]) {
        self.results = results
    }
}
