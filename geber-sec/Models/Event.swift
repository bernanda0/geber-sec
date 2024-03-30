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

struct Ref {
    let location: String
    let numberOfCalls: Int
    let latestCall: String
}

enum SectionLocation {
    case s1, s2, s3
}

let mock_data = [
        Ref(location: "Location A", numberOfCalls: 10, latestCall: "09:00:00"),
        Ref(location: "Location B", numberOfCalls: 5, latestCall: "09:00:12"),
        Ref(location: "Location C", numberOfCalls: 15, latestCall: "09:00:13")
]
