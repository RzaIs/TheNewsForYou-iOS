//
//  Array+Extension.swift
//  Domain
//
//  Created by Rza Ismayilov on 10.09.22.
//

public class SafeArray<Element> {
    private let array: Array<Element>
    
    init(_ array: [Element]) {
        self.array = array
    }
    
    public subscript(index: Int) -> Element? {
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
