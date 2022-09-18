//
//  PublishDateEntity.swift
//  Domain
//
//  Created by Rza Ismayilov on 11.09.22.
//

public enum PublishDateEntity: Comparable {
    case at(Date)
    case unknown
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.at(let lDate), .at(let rDate)):
            return lDate < rDate
        case (.unknown, .at(_)):
            return true
        default:
            return false
        }
    }
}
