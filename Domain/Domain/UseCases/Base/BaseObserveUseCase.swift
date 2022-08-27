//
//  BaseObserveUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

import RxSwift

public class BaseObserveUseCase<Input, Output> {
    public func observe(input: Input) -> Observable<Output> {
        fatalError("Method Not Implemented")
    }
}
