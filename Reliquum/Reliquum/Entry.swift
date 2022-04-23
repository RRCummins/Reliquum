//
//  Entry.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/22/22.
//

import SwiftUI

enum ColorItems: Codable {
    case red, blue, green, yellow, mint, indigo, brown, black, white, pink, purple, orange
}

struct Entry: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    let name: String
    let date: Date
    let colors: [ColorItems]
    let imageURL: String
    let description: String
    let reminder: Bool
    
}

extension Entry {
    static var example = Entry(name: "Example", date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(), colors: [.indigo, .white], imageURL: "", description: "", reminder: false)
}
