//
//  MatchStateTests.swift
//  CourtSide
//
//  Created by Kassim Mirza on 02/02/2026.
//

import Testing
@testable import CourtSide_Watch_App

@MainActor
@Suite("Match State Tests")
struct MatchStateTests {
    
    // MARK: - Initialization
    
    @Test("Default initialization creates empty match state")
    func testDefaultInitialization() {
        let state = MatchState()
        
        #expect(state.score.sets.count == 1)
        #expect(state.score.sets[0].us == 0)
        #expect(state.score.sets[0].them == 0)
        #expect(state.score.currentGame.us == 0)
        #expect(state.score.currentGame.them == 0)
        #expect(state.serve.servingTeam == .us)
        #expect(state.serve.serverIndex == 0)
        #expect(state.serve.side == .deuce)
        #expect(state.history.isEmpty)
    }
    
    @Test("Custom initialization preserves values")
    func testCustomInitialization() {
        let customScore = MatchScore(
            sets: [SetScore(us: 6, them: 4)],
            currentGame: GamePoints(us: 2, them: 1)
        )
        let customServe = ServeState(servingTeam: .them, serverIndex: 1, side: .advantage)
        
        let state = MatchState(score: customScore, serve: customServe, history: [])
        
        #expect(state.score.sets[0].us == 6)
        #expect(state.score.sets[0].them == 4)
        #expect(state.score.currentGame.us == 2)
        #expect(state.score.currentGame.them == 1)
        #expect(state.serve.servingTeam == .them)
        #expect(state.serve.serverIndex == 1)
        #expect(state.serve.side == .advantage)
    }
    
    // MARK: - Snapshot Management
    
    @Test("Save snapshot adds to history")
    func testSaveSnapshot() {
        var state = MatchState()
        state.score.currentGame.us = 1
        state.score.currentGame.them = 2
        
        state.saveSnapshot()
        
        #expect(state.history.count == 1)
        #expect(state.history[0].0.currentGame.us == 1)
        #expect(state.history[0].0.currentGame.them == 2)
    }
    
    @Test("Save multiple snapshots preserves order")
    func testSaveMultipleSnapshots() {
        var state = MatchState()
        
        state.score.currentGame.us = 1
        state.saveSnapshot()
        
        state.score.currentGame.us = 2
        state.saveSnapshot()
        
        state.score.currentGame.us = 3
        state.saveSnapshot()
        
        #expect(state.history.count == 3)
        #expect(state.history[0].0.currentGame.us == 1)
        #expect(state.history[1].0.currentGame.us == 2)
        #expect(state.history[2].0.currentGame.us == 3)
    }
    
    @Test("Snapshot limit enforced at 50")
    func testSnapshotLimitTo50() {
        var state = MatchState()
        
        // Add 60 snapshots
        for i in 0..<60 {
            state.score.currentGame.us = i
            state.saveSnapshot()
        }
        
        // Should only keep the last 50
        #expect(state.history.count == 50)
        
        // First snapshot should be from iteration 10 (0-9 were removed)
        #expect(state.history[0].0.currentGame.us == 10)
        
        // Last snapshot should be from iteration 59
        #expect(state.history[49].0.currentGame.us == 59)
    }
    
    @Test("Snapshot captures serve state")
    func testSnapshotCapturesServeState() {
        var state = MatchState()
        state.serve.servingTeam = .them
        state.serve.side = .advantage
        
        state.saveSnapshot()
        
        #expect(state.history[0].1.servingTeam == .them)
        #expect(state.history[0].1.side == .advantage)
    }
    
    // MARK: - Restore Snapshot
    
    @Test("Restore last snapshot returns to previous state")
    func testRestoreLastSnapshot() {
        var state = MatchState()
        state.score.currentGame.us = 1
        state.saveSnapshot()
        
        state.score.currentGame.us = 2
        state.score.currentGame.them = 3
        
        let restored = state.restoreLastSnapshot()
        
        #expect(restored == true)
        #expect(state.score.currentGame.us == 1)
        #expect(state.score.currentGame.them == 0)
        #expect(state.history.isEmpty)
    }
    
    @Test("Restore empty history returns false")
    func testRestoreEmptyHistoryReturnsFalse() {
        var state = MatchState()
        let restored = state.restoreLastSnapshot()
        
        #expect(restored == false)
    }
    
    @Test("Restore multiple times works correctly")
    func testRestoreMultipleTimes() {
        var state = MatchState()
        
        state.score.currentGame.us = 1
        state.saveSnapshot()
        
        state.score.currentGame.us = 2
        state.saveSnapshot()
        
        state.score.currentGame.us = 3
        
        // First restore
        #expect(state.restoreLastSnapshot() == true)
        #expect(state.score.currentGame.us == 2)
        #expect(state.history.count == 1)
        
        // Second restore
        #expect(state.restoreLastSnapshot() == true)
        #expect(state.score.currentGame.us == 1)
        #expect(state.history.count == 0)
        
        // Third restore should fail
        #expect(state.restoreLastSnapshot() == false)
    }
    
    @Test("Restore snapshot restores serve state")
    func testRestoreServeState() {
        var state = MatchState()
        state.serve.servingTeam = .us
        state.serve.side = .deuce
        state.saveSnapshot()
        
        state.serve.servingTeam = .them
        state.serve.side = .advantage
        
        _ = state.restoreLastSnapshot()
        
        #expect(state.serve.servingTeam == .us)
        #expect(state.serve.side == .deuce)
    }
    
    // MARK: - Reset
    
    @Test("Reset returns state to default")
    func testReset() {
        var state = MatchState()
        
        // Modify state
        state.score.sets.append(SetScore(us: 6, them: 4))
        state.score.currentGame.us = 3
        state.score.currentGame.them = 2
        state.serve.servingTeam = .them
        state.serve.side = .advantage
        state.saveSnapshot()
        state.saveSnapshot()
        
        state.reset()
        
        // Verify reset to defaults
        #expect(state.score.sets.count == 1)
        #expect(state.score.sets[0].us == 0)
        #expect(state.score.sets[0].them == 0)
        #expect(state.score.currentGame.us == 0)
        #expect(state.score.currentGame.them == 0)
        #expect(state.serve.servingTeam == .us)
        #expect(state.serve.side == .deuce)
        #expect(state.history.isEmpty)
    }
}
