//
//  ServeState.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

struct ServeState {
    var servingTeam: Team
    var serverIndex: Int    // 0 or 1 within team
    var side: CourtSide
}

extension ServeState {
    func arrow(for side: CourtSide) -> String {
        switch (servingTeam, side) {
        case (.us, .deuce):         return "arrow.down.right"
        case (.us, .advantage):     return "arrow.down.left"
        case (.them, .deuce):       return "arrow.up.left"
        case (.them, .advantage):   return "arrow.up.right"
        }
//        
//        switch (servingTeam, side) {
//        case (.us, .deuce):         return "arrow.right"
//        case (.us, .advantage):     return "arrow.left"
//        case (.them, .deuce):       return "arrow.left"
//        case (.them, .advantage):   return "arrow.right"
//        }
    }
}
