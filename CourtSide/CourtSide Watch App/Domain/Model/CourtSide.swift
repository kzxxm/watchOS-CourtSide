//
//  CourtSide.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

enum CourtSide {
    case deuce, advantage
    
    mutating func toggle() {
        self = self == .deuce ? .advantage : .deuce
    }
}
