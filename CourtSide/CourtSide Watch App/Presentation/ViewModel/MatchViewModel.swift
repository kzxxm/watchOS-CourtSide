//
//  MatchViewModel.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

import Foundation
import Observation
import SwiftUI

// MARK: - Main ViewModel

@Observable
final class MatchViewModel {
    
    // MARK: - State
    private(set) var matchState: MatchState
    private(set) var presentationState: PresentationState
    let settings: MatchSettings
    
    // MARK: - Computed Properties (Public API)
    
    var match: MatchScore {
        matchState.score
    }
    
    var serve: ServeState {
        matchState.serve
    }
    
    var gameWinner: Team? {
        presentationState.gameWinner
    }
    
    var setWinner: Team? {
        presentationState.setWinner
    }
    
    var showSetSummary: Bool {
        presentationState.showSetSummary
    }
    
    var showSettings: Bool {
        presentationState.showSettings
    }
    
    var needsServeSelection: Bool {
        presentationState.needsServeSelection
    }
    
    var canUndo: Bool {
        !matchState.history.isEmpty
    }
    
    var swapPositions: Bool = false
    
    var completedSets: [SetScore] {
        let sets = matchState.score.sets
        // Exclude the current (incomplete) set
        if let lastSet = sets.last, lastSet.us == 0 && lastSet.them == 0 {
            return Array(sets.dropLast())
        }
        return sets
    }
    
    // MARK: - Private Task Management
    
    private var gameWinTask: Task<Void, Never>?
    
    // MARK: - Init
    
    init(
        settings: MatchSettings = MatchSettings(),
        matchState: MatchState = MatchState(),
        presentationState: PresentationState = PresentationState()
    ) {
        self.settings = settings
        self.matchState = matchState
        self.presentationState = presentationState
    }
    
    deinit {
        gameWinTask?.cancel()
    }
    
    // MARK: - Public Intents
    
    func pointWon(by team: Team) {
        matchState.saveSnapshot()
        incrementPoint(for: team)
        
        if let winner = GameRules.gameWinner(
            usPoints: matchState.score.currentGame.us,
            themPoints: matchState.score.currentGame.them,
            goldenPointEnabled: settings.goldenPointEnabled
        ) {
            gameWon(by: winner)
        } else {
            updateServeSide()
        }
    }
    
    func selectInitialServer(team: Team) {
        matchState.serve = ServeState(
            servingTeam: team,
            serverIndex: 0,
            side: .deuce
        )
        
        swapPositions = matchState.serve.servingTeam == .us ? false : true
        presentationState.completeServeSelection()
    }
    
    func undo() {
        _ = matchState.restoreLastSnapshot()
    }
    
    func resetMatch() {
        gameWinTask?.cancel()
        matchState.reset()
        presentationState = PresentationState()
        swapPositions = false
    }
    
    func presentSettings() {
        presentationState.presentSettings()
    }
    
    func dismissGameWinner() {
        presentationState.dismissGameWinner()
    }
    
    func dismissSetWinner() {
        presentationState.dismissSetWinner()
    }
    
    func dismissSetSummary() {
        presentationState.dismissSetSummary()
    }
    
    func dismissSettings() {
        presentationState.dismissSettings()
    }
    
    func changeTeamColors(to theme: TeamColor) {
        settings.applyTheme(theme)
    }
    
    // MARK: - Private Game Logic
    
    private func incrementPoint(for team: Team) {
        switch team {
        case .us:
            matchState.score.currentGame.us += 1
        case .them:
            matchState.score.currentGame.them += 1
        }
    }
    
    private func updateServeSide() {
        matchState.serve.side = ServeRules.nextSide(current: matchState.serve.side)
    }
    
    private func gameWon(by team: Team) {
        // Cancel any existing game win animation
        gameWinTask?.cancel()
        
        // Start new game win sequence
        gameWinTask = Task { @MainActor in
            do {
                try await Task.sleep(for: AnimationTimings.preWinDelay)
                guard !Task.isCancelled else { return }
                
                presentationState.gameWinner = team
                HapticsManager.gameWin()
                
                try await Task.sleep(for: AnimationTimings.winDisplayDuration)
                guard !Task.isCancelled else { return }
                
                dismissGameWinner()
            } catch {
                // Task cancelled or other error - gracefully exit
            }
        }
        
        // Update game state
        resetGamePoints()
        incrementGame(for: team)
        rotateServer()
        
        // Check for set win
        if let setWinner = SetRules.setWinner(
            usGames: currentSet.us,
            themGames: currentSet.them,
            tieBreakEnabled: settings.tieBreakEnabled
        ) {
            setWon(by: setWinner)
        }
    }
    
    private func setWon(by team: Team) {
        presentationState.showSetWinner(team)
        HapticsManager.setWin()
        matchState.score.sets.append(SetScore())
    }
    
    private func resetGamePoints() {
        matchState.score.currentGame = GamePoints()
        matchState.serve.side = .deuce
    }
    
    private func incrementGame(for team: Team) {
        let index = currentSetIndex
        switch team {
        case .us:
            matchState.score.sets[index].us += 1
        case .them:
            matchState.score.sets[index].them += 1
        }
    }
    
    private func rotateServer() {
        matchState.serve = ServeRules.nextServer(afterGame: matchState.serve)
        swapPositions.toggle()
    }
    
    // MARK: - Private Helpers
    
    private var currentSetIndex: Int {
        if matchState.score.sets.isEmpty {
            matchState.score.sets.append(SetScore())
        }
        return matchState.score.sets.count - 1
    }
    
    private var currentSet: SetScore {
        matchState.score.sets[currentSetIndex]
    }
}

// MARK: - Animation Timings

private enum AnimationTimings {
    static let preWinDelay: Duration = .seconds(0.5)
    static let winDisplayDuration: Duration = .seconds(3)
}
