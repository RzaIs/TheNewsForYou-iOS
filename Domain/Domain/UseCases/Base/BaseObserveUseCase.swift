//
//  BaseObserveUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Combine

public class BaseObserveUseCase<Input, Output> {
    public func observe(input: Input) -> AnyPublisher<Output, Never> {
        fatalError("Method Not Implemented")
    }
}
