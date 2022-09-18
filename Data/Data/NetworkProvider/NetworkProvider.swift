//
//  NetworkProvider.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Alamofire

class NetworkProvider: NetworkProviderProtocol {

    private let firebaseProvider: FirebaseProviderProtocol
    private let baseURL: String
    private let logger: Logger
    private let session: Session
    
    init(firebaseProvider: FirebaseProviderProtocol,
         baseURL: String,
         logger: Logger,
         adapters: [RequestAdapter],
         retriers: [RequestRetrier]
    ) {
        self.firebaseProvider = firebaseProvider
        self.baseURL = baseURL
        self.logger = logger
        self.session = Session(
            interceptor: Interceptor(
                adapters: adapters,
                retriers: retriers
            )
        )
    }
    
    func fullUrl(endpoint: String) async throws -> String {
        if let apiKey = self.firebaseProvider.getApiKey(), !apiKey.isEmpty {
            return "\(self.baseURL)/\(endpoint)".replacingOccurrences(of: "{apiKey}", with: apiKey)
        } else {
            try await self.firebaseProvider.syncRemoteConfig()
            let apiKey = self.firebaseProvider.getApiKey() ?? ""
            return "\(self.baseURL)/\(endpoint)".replacingOccurrences(of: "{apiKey}", with: apiKey)
        }

    }
    
    func request<I: Encodable, O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I,
        retry: Bool
    ) async throws -> O {
        let url = try await self.fullUrl(endpoint: endpoint)
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoder: encoder,
                headers: headers
            ).responseDecodable(of: O.self) { response in
                self.logger.log(response: response)
                if let obj = response.value {
                    continuation.resume(returning: obj)
                } else if response.response?.statusCode == 401, retry {
                    self.retry(continuation: continuation) {
                        try await self.request(
                            endpoint: endpoint,
                            method: method,
                            headers: headers,
                            encoder: encoder,
                            parameters: parameters,
                            retry: false
                        )
                    }
                } else if let error = response.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Network-Request", code: 1))
                }
            }
        }
    }
    
    func request<O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        retry: Bool
    ) async throws -> O {
        let url = try await self.fullUrl(endpoint: endpoint)
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                url,
                method: method,
                parameters: nil,
                headers: headers
            ).responseDecodable(of: O.self) { response in
                self.logger.log(response: response)
                if let obj = response.value {
                    continuation.resume(returning: obj)
                } else if response.response?.statusCode == 401, retry {
                    self.retry(continuation: continuation) {
                        try await self.request(
                            endpoint: endpoint,
                            method: method,
                            headers: headers,
                            retry: false
                        )
                    }
                } else if let error = response.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Network-Request", code: 2))
                }
            }
        }
    }
    
    func request<I: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I,
        retry: Bool
    ) async throws {
        let url = try await self.fullUrl(endpoint: endpoint)
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoder: encoder,
                headers: headers
            ).response { response in
                self.logger.log(response: response)
                if let status = response.response?.statusCode, status >= 200, status <= 299 {
                    continuation.resume()
                } else if response.response?.statusCode == 401 {
                    self.retry(continuation: continuation) {
                        try await self.request(
                            endpoint: endpoint,
                            method: method,
                            headers: headers,
                            encoder: encoder,
                            parameters: parameters,
                            retry: false
                        )
                    }
                } else if let error = response.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "Network-Request", code: 4))
                }
            }
        }
    }
    
    func retry<O>(continuation: CheckedContinuation<O, Error>, task: @escaping () async throws -> O) {
        Task {
            do {
                try await self.firebaseProvider.syncRemoteConfig()
                let result: O = try await task()
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

class EmptyParameters: Codable {}
