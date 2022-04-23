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
    let id: UUID
    let name: String
    let date: Date
    let colors: [ColorItems]
    let imageURL: String
    let description: String
    let reminder: Bool
    
}
