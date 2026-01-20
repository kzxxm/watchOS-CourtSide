//
//  Score.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

struct SetScore {
    var us: Int = 0
    var them: Int = 0
}

struct MatchScore {
    var sets: [SetScore] = [SetScore()]
    var currentGame: GamePoints = GamePoints()
}
