//
//  Utilities.swift
//  geber-sec
//
//  Created by bernanda on 31/03/24.
//

import Foundation

final class Util {
    static func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
}
