//
//  MatchViewModel.swift
//  CourtSide
//
//  Created by Kassim Mirza on 20/01/2026.
//

import Foundation
import Observation
import SwiftUI

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

// MARK: - Settings

enum DefaultsKey: String {
    case goldenPointEnabled = "goldenPoint"
    case tieBreakEnabled = "tieBreak"
    case team1Color = "team1Color"
    case team2Color = "team2Color"
    case selectedTheme = "selectedTheme"
}

@Observable
final class MatchSettings {
    @ObservationIgnored
    @AppStorage(DefaultsKey.goldenPointEnabled.rawValue) var goldenPointEnabled = false
    
    @ObservationIgnored
    @AppStorage(DefaultsKey.tieBreakEnabled.rawValue) var tieBreakEnabled = false
    
    @ObservationIgnored
    @AppStorage(DefaultsKey.team1Color.rawValue) private var _team1Color = Color.blue
    
    @ObservationIgnored
    @AppStorage(DefaultsKey.team2Color.rawValue) private var _team2Color = Color.orange
    
    @ObservationIgnored
    @AppStorage(DefaultsKey.selectedTheme.rawValue) private var _selectedThemeRawValue = TeamColor.blueOrange.rawValue
    
    // Observable properties that manually trigger updates
        var team1Color: Color {
            get {
                access(keyPath: \.team1Color)
                return _team1Color
            }
            set {
                withMutation(keyPath: \.team1Color) {
                    _team1Color = newValue
                }
            }
        }
        
        var team2Color: Color {
            get {
                access(keyPath: \.team2Color)
                return _team2Color
            }
            set {
                withMutation(keyPath: \.team2Color) {
                    _team2Color = newValue
                }
            }
        }
        
        var selectedTheme: TeamColor {
            get {
                access(keyPath: \.selectedTheme)
                return TeamColor(rawValue: _selectedThemeRawValue) ?? .blueOrange
            }
            set {
                withMutation(keyPath: \.selectedTheme) {
                    _selectedThemeRawValue = newValue.rawValue
                    _team1Color = newValue.team1Color
                    _team2Color = newValue.team2Color
                }
            }
        }
        
        func applyTheme(_ theme: TeamColor) {
            selectedTheme = theme
        }
}

// MARK: - Animation Timings

private enum AnimationTimings {
    static let preWinDelay: Duration = .seconds(0.5)
    static let winDisplayDuration: Duration = .seconds(3)
}

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
