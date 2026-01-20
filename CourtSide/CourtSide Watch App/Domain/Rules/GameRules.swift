//
//  GameRules.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

/// Logic for winning a game + optional golden rule logic

import Foundation

struct GameRules {
    static func gameWinner(usPoints: Int, themPoints: Int, goldenPointEnabled: Bool) -> Team? {
        
        // Golden Point: First point at deuce wins
        if goldenPointEnabled && usPoints == 4 && themPoints == 3 {
            return .us
        }
        
        if goldenPointEnabled && themPoints == 4 && usPoints == 3 {
            return .them
        }
        
        // Standard Rules
        guard usPoints >= 4 || themPoints >= 4 else {
            return nil
        }
        
        let diff = usPoints - themPoints
        
        if abs(diff) >= 2 {
            return diff > 0 ? .us : .them
        }
        
        return nil
    }
}
