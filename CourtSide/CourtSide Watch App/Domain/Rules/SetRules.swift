//
//  SetRules.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

/// Logic for winning a set

import Foundation

struct SetRules {
    static func setWinner(
        usGames: Int,
        themGames: Int,
        tieBreakEnabled: Bool
    ) -> Team? {
        
        // Tie-break case (e.g. 6-6)
        if tieBreakEnabled && usGames == 7 && themGames == 6 {
            return .us
        }
        
        if tieBreakEnabled && themGames == 7 && usGames == 6 {
            return .them
        }
        
        // Normal set win
        guard usGames >= 6 || themGames >= 6 else {
            return nil
        }
        
        let diff = usGames - themGames
        
        if abs(diff) >= 2 {
            return diff > 0 ? .us : .them
        }
        
        return nil
    }
}
