//
//  PresentationState.swift
//  CourtSide
//
//  Created by Kassim Mirza on 28/01/2026.
//

import Foundation

// MARK: - Presentation State (UI-specific)

struct PresentationState {
    var gameWinner: Team?
    var setWinner: Team?
    var showSetSummary: Bool
    var needsServeSelection: Bool
    var showSettings: Bool
    
    init(
        gameWinner: Team? = nil,
        setWinner: Team? = nil,
        showSetSummary: Bool = false,
        needsServeSelection: Bool = true,
        showSettings: Bool = false
    ) {
        self.gameWinner = gameWinner
        self.setWinner = setWinner
        self.showSetSummary = showSetSummary
        self.needsServeSelection = needsServeSelection
        self.showSettings = showSettings
    }
    
    mutating func dismissGameWinner() {
        gameWinner = nil
    }
    
    mutating func showSetWinner(_ team: Team) {
        setWinner = team
    }
    
    mutating func dismissSetWinner() {
        setWinner = nil
        showSetSummary = true
    }
    
    mutating func dismissSetSummary() {
        showSetSummary = false
        needsServeSelection = true
    }
    
    mutating func completeServeSelection() {
        needsServeSelection = false
    }
    
    mutating func presentSettings() {
        showSettings = true
    }
    
    mutating func dismissSettings() {
        showSettings = false
    }
}
