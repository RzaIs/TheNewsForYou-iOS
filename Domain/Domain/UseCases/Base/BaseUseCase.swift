//
//  BaseUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

public class BaseUseCase<Input, Output> {
    public func execute(input: Input) -> Output {
        fatalError("Method Not Implemented")
    }
}
