//
//  TeamColor.swift
//  CourtSide
//
//  Created by Kassim Mirza on 27/01/2026.
//

import SwiftUI

enum TeamColor: String, CaseIterable, Identifiable {
    case blueOrange
    case redGreen
    case yellowPurple
    case pinkTeal
    case mintIndigo
    case brownCyan
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .blueOrange:
            "Blue & Orange"
        case .redGreen:
            "Red & Green"
        case .yellowPurple:
            "Yellow & Purple"
        case .pinkTeal:
            "Pink & Teal"
        case .mintIndigo:
            "Mint & Indigo"
        case .brownCyan:
            "Brown & Cyan"
        }
    }
    
    var team1Color: Color {
        switch self {
        case .blueOrange:
            return .blue
        case .redGreen:
            return .red
        case .yellowPurple:
            return .yellow
        case .pinkTeal:
            return .pink
        case .mintIndigo:
            return .mint
        case .brownCyan:
            return .brown
        }
    }
    
    var team2Color: Color {
        switch self {
        case .blueOrange:
            return .orange
        case .redGreen:
            return .green
        case .yellowPurple:
            return .purple
        case .pinkTeal:
            return .teal
        case .mintIndigo:
            return .indigo
        case .brownCyan:
            return .cyan
        }
    }
}

extension Color: @retroactive RawRepresentable {
    public init?(rawValue: String) {
        do {
            let encodedData = rawValue.data(using: .utf8)!
            let components = try JSONDecoder().decode([Double].self, from: encodedData)
            self = Color(
                red: components[0],
                green: components[1],
                blue: components[2],
                opacity: components[3]
            )
        } catch {
            return nil
        }
    }
  
    public var rawValue: String {
        guard let cgFloatComponents = UIColor(self).cgColor.components else { return "" }
        let doubleComponents = cgFloatComponents.map { Double($0) }
        do {
            let encodedComponents = try JSONEncoder().encode(doubleComponents)
            return String(data: encodedComponents, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}


