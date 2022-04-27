//
//  ColorItem.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/22/22.
//

import SwiftUI

enum ColorItems: Codable, CaseIterable {
    case red
    case blue
    case green
    case yellow
    case mint
    case indigo
    case brown
    case black
    case white
    case pink
    case purple
    case orange
    
    var itemColor: Color {
        switch self {
        case .red:
            return Color.red
        case .blue:
            return Color.blue
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        case .mint:
            return Color.mint
        case .indigo:
            return Color.indigo
        case .brown:
            return Color.brown
        case .black:
            return Color.black
        case .white:
            return Color.white
        case .pink:
            return Color.pink
        case .purple:
            return Color.purple
        case .orange:
            return Color.orange
        }
    }
}
