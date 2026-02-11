//
//  Date+Extension.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public extension Date {
    
    func formatedTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
