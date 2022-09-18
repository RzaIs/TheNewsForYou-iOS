//
//  LogAdapter.swift
//  Data
//
//  Created by Rza Ismayilov on 02.09.22.
//

import Alamofire

class LogAdapter: RequestAdapter {
    
    let logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        logger.log(request: urlRequest)
        completion(.success(urlRequest))
    }
}
