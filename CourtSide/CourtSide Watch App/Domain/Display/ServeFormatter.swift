//
//  ServeFormatter.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

import Foundation

struct ServeFormatter {
    static func sideText(_ side: CourtSide) -> String {
        side == .deuce ? "DEUCE" : "ADV"
    }
    
    static func teamText(_ team: Team) -> String {
        team == .us ? "US" : "THEM"
    }
}
