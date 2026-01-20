//
//  ServeRules.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

/// Logic to pick court side, server side and rotations

import Foundation

struct ServeRules {
    static func nextSide(current: CourtSide) -> CourtSide {
        current == .deuce ? .advantage : .deuce
    }
    
    static func nextServer(afterGame serve: ServeState) -> ServeState {
        ServeState(
            servingTeam: serve.servingTeam == .us ? .them : .us,
            serverIndex: 0,
            side: .deuce
        )
    }
}
