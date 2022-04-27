//
//  Event.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/22/22.
//

import SwiftUI

struct Event: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    let name: String
    let date: Date
    let colors: [ColorItems]
    let imageURL: String
    let description: String
    let reminder: Bool
    
}

extension Event {
    static var example = Event(name: "Example", date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(), colors: [.indigo, .white], imageURL: "", description: "", reminder: false)
}
