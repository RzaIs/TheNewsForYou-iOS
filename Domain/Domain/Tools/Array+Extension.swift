//
//  Array+Extension.swift
//  Domain
//
//  Created by Rza Ismayilov on 10.09.22.
//

public class SafeArray<T> {
    private let array: Array<T>
    
    init(_ array: [T]) {
        self.array = array
    }
    
    public subscript(index: Int) -> T? {
        if index < array.count && index >= 0 {
            return self.array[index]
        } else {
            return nil
        }
    }
}

extension Array {
    public var safe: SafeArray<Element> {
        SafeArray(self)
    }
}
