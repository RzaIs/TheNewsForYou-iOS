//
//  NetworkProviderProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Alamofire

protocol NetworkProviderProtocol {
    func request<I: Encodable, O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws -> O
    
    func request<O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders
    ) async throws -> O
    
    func request<I: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws
}
