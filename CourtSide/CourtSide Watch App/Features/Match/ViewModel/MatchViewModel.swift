//
//  MatchViewModel.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

import Foundation
import Observation

@Observable
final class MatchViewModel {
    
    // MARK: - Published state (read-only values)
    private(set) var match: MatchScore
    private(set) var serve: ServeState
    private(set) var setWinner: Team? = nil
    private(set) var showSetSummary = false
    private(set) var needsServeSelection = true
    var gameWinner: Team? = nil
    var swapPositions: Bool = false
    
    // MARK: - Settings
    // TODO: Integrate UserDefaults
    let goldenPointEnabled: Bool
    let tieBreakEnabled: Bool
    
    // MARK: - Undo history
    private var history: [(MatchScore, ServeState)] = []
    
    // MARK: - Completed Sets (for summary view)
    var completedSets: [SetScore] {
        let sets = match.sets
        // Exclude the current (incomplete) set
        if let lastSet = sets.last, lastSet.us == 0 && lastSet.them == 0 {
            return Array(sets.dropLast())
        }
        return sets
    }
    
    // MARK: - Init
    init(
        goldenPointEnabled: Bool = false,
        tieBreakEnabled: Bool = false
    ) {
        self.goldenPointEnabled = goldenPointEnabled
        self.tieBreakEnabled = tieBreakEnabled
        self.match = MatchScore()
        self.serve = ServeState(
            servingTeam: .us,
            serverIndex: 0,
            side: .deuce
        )
    }
    
    // MARK: - Public intents
    func pointWon(by team: Team) {
        saveSnapshot()
        incrementPoint(for: team)
        
        if let gameWinner = GameRules.gameWinner(
            usPoints: match.currentGame.us,
            themPoints: match.currentGame.them,
            goldenPointEnabled: goldenPointEnabled
        ) {
            gameWon(by: gameWinner)
        } else {
            updateServeSide()
        }
    }
    
    func selectInitialServer(team: Team) {
        serve = ServeState(
            servingTeam: team,
            serverIndex: 0,
            side: .deuce
        )
        needsServeSelection = false
    }
    
    func undo() {
        guard let last = history.popLast() else { return }
        match = last.0
        serve = last.1
    }
    
    func resetMatch() {
        history.removeAll()
        match = MatchScore()
        serve = ServeState(
            servingTeam: .us,
            serverIndex: 0,
            side: .deuce
        )
        needsServeSelection = true
    }
    
    func dismissGameWinner() {
        gameWinner = nil
    }
    
    func dismissSetWinner() {
        setWinner = nil
        showSetSummary = true
    }
    
    func dismissSetSummary() {
        showSetSummary = false
        needsServeSelection = true
    }
    
    // MARK: - Helpers
    private func saveSnapshot() {
        history.append((match, serve))
    }
    
    private func incrementPoint(for team: Team) {
        switch team {
        case .us:
            match.currentGame.us += 1
        case .them:
            match.currentGame.them += 1
        }
    }
    
    private func updateServeSide() {
        serve.side = ServeRules.nextSide(current: serve.side)
    }
    
    private func gameWon(by team: Team) {
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.5))
            gameWinner = team

            try? await Task.sleep(for: .seconds(3))
            dismissGameWinner()
        }
        
        resetGamePoints()
        incrementGame(for: team)
        rotateServer()
        
        if let setWinner = SetRules.setWinner(
            usGames: currentSet.us,
            themGames: currentSet.them,
            tieBreakEnabled: tieBreakEnabled
        ) {
            setWon(by: setWinner)
        }
    }
    
    private func setWon(by team: Team) {
        setWinner = team
        match.sets.append(SetScore())
    }
    
    private func resetGamePoints() {
        match.currentGame = GamePoints()
        serve.side = .deuce
    }
    
    private func incrementGame(for team: Team) {
        let index = match.sets.count - 1
        
        switch team {
        case .us:
            match.sets[index].us += 1
        case .them:
            match.sets[index].them += 1
        }
    }
    
    private func rotateServer() {
        serve = ServeRules.nextServer(afterGame: serve)
        swapPositions.toggle()
    }
    
    // MARK: - Convenience accessors
    private var currentSet: SetScore {
        if match.sets.isEmpty {
            match.sets.append(SetScore())
        }
        return match.sets[match.sets.count - 1]
    }

}
