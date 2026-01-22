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
    var swapPositions: Bool = false
    
    // MARK: - Settings
    // TODO: Integrate UserDefaults
    let goldenPointEnabled: Bool
    let tieBreakEnabled: Bool
    
    // MARK: - Undo history
    private var history: [(MatchScore, ServeState)] = []
    
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
