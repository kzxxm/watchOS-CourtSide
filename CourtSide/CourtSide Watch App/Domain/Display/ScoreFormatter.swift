//
//  ScoreFormatter.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

import Foundation

struct ScoreFormatter {
    static func point(
        points: Int,
        opponentPoints: Int,
        goldenPointEnabled: Bool
    ) -> DisplayPoint {
        
        // Golden point deuce logic
        if goldenPointEnabled && points == 3 && opponentPoints == 3 {
            return .forty
        }
        
        // Deuce/Advantage
        if points >= 3 && opponentPoints >= 3 {
            if points == opponentPoints {
                return .forty
            }
            return points > opponentPoints ? .advantage : .forty
        }
        
        switch points {
        case 0: return .love
        case 1: return .fifteen
        case 2: return .thirty
        default: return .forty
        }
    }
}
