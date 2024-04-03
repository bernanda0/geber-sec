//
//  Event.swift
//  geber-sec
//
//  Created by bernanda on 31/03/24.
//

import Foundation


struct Event {
    let event_id: String
    let location: SectionLocation
    let timestamp: Date
}

struct Row {
    var location: SectionLocation
    var numberOfCalls: Int
    var latestCall: String
}

enum SectionLocation {
    case s1, s2, s3
}

