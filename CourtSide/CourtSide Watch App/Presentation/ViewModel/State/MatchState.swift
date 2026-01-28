//
//  MatchState.swift
//  CourtSide
//
//  Created by Kassim Mirza on 28/01/2026.
//

import Foundation

// MARK: - Match State (Pure Data)

struct MatchState {
    var score: MatchScore
    var serve: ServeState
    var history: [(MatchScore, ServeState)]
    
    init(
        score: MatchScore = MatchScore(),
        serve: ServeState = ServeState(servingTeam: .us, serverIndex: 0, side: .deuce),
        history: [(MatchScore, ServeState)] = []
    ) {
        self.score = score
        self.serve = serve
        self.history = history
    }
    
    mutating func saveSnapshot() {
        history.append((score, serve))
        // Limit history size to prevent memory issues
        if history.count > 50 {
            history.removeFirst()
        }
    }
    
    mutating func restoreLastSnapshot() -> Bool {
        guard let last = history.popLast() else { return false }
        score = last.0
        serve = last.1
        return true
    }
    
    mutating func reset() {
        score = MatchScore()
        serve = ServeState(servingTeam: .us, serverIndex: 0, side: .deuce)
        history.removeAll()
    }
}
