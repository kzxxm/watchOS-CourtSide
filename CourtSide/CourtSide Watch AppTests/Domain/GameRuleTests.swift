//
//  GameRuleTests.swift
//  CourtSide
//
//  Created by Kassim Mirza on 02/02/2026.
//

import Testing
@testable import CourtSide_Watch_App

@MainActor
@Suite("Game Rules Tests")
struct GameRulesTests {
    
    // MARK: - Standard Game Rules
    
    @Test("No winner when score is 0-0")
    func testNoWinnerWhenScoreIsZeroZero() {
        let winner = GameRules.gameWinner(usPoints: 0, themPoints: 0, goldenPointEnabled: false)
        #expect(winner == nil)
    }
    
    @Test("No winner when both players are below 4 points")
    func testNoWinnerWhenScoreIsBelowFour() {
        #expect(GameRules.gameWinner(usPoints: 3, themPoints: 2, goldenPointEnabled: false) == nil)
        #expect(GameRules.gameWinner(usPoints: 2, themPoints: 3, goldenPointEnabled: false) == nil)
        #expect(GameRules.gameWinner(usPoints: 3, themPoints: 0, goldenPointEnabled: false) == nil)
    }
    
    @Test("Us wins with 4-0")
    func testUsWinsWithFourToZero() {
        let winner = GameRules.gameWinner(usPoints: 4, themPoints: 0, goldenPointEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Us wins with 4-1")
    func testUsWinsWithFourToOne() {
        let winner = GameRules.gameWinner(usPoints: 4, themPoints: 1, goldenPointEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Us wins with 4-2")
    func testUsWinsWithFourToTwo() {
        let winner = GameRules.gameWinner(usPoints: 4, themPoints: 2, goldenPointEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Them wins with 4-0")
    func testThemWinsWithFourToZero() {
        let winner = GameRules.gameWinner(usPoints: 0, themPoints: 4, goldenPointEnabled: false)
        #expect(winner == .them)
    }
    
    @Test("Them wins with 4-1")
    func testThemWinsWithFourToOne() {
        let winner = GameRules.gameWinner(usPoints: 1, themPoints: 4, goldenPointEnabled: false)
        #expect(winner == .them)
    }
    
    @Test("Them wins with 4-2")
    func testThemWinsWithFourToTwo() {
        let winner = GameRules.gameWinner(usPoints: 2, themPoints: 4, goldenPointEnabled: false)
        #expect(winner == .them)
    }
    
    // MARK: - Deuce Scenarios
    
    @Test("No winner at deuce (3-3)")
    func testNoWinnerAtDeuce() {
        let winner = GameRules.gameWinner(usPoints: 3, themPoints: 3, goldenPointEnabled: false)
        #expect(winner == nil)
    }
    
    @Test("No winner when difference is only one point", arguments: [
        (4, 3), (3, 4), (5, 4), (4, 5)
    ])
    func testNoWinnerWhenDifferenceIsOnlyOne(usPoints: Int, themPoints: Int) {
        #expect(GameRules.gameWinner(usPoints: usPoints, themPoints: themPoints, goldenPointEnabled: false) == nil)
    }
    
    @Test("Us wins after deuce with 2-point advantage")
    func testUsWinsAfterDeuce() {
        let winner = GameRules.gameWinner(usPoints: 5, themPoints: 3, goldenPointEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Them wins after deuce with 2-point advantage")
    func testThemWinsAfterDeuce() {
        let winner = GameRules.gameWinner(usPoints: 3, themPoints: 5, goldenPointEnabled: false)
        #expect(winner == .them)
    }
    
    @Test("Us wins at high score with 2-point advantage")
    func testUsWinsAtHighScore() {
        let winner = GameRules.gameWinner(usPoints: 10, themPoints: 8, goldenPointEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Them wins at high score with 2-point advantage")
    func testThemWinsAtHighScore() {
        let winner = GameRules.gameWinner(usPoints: 8, themPoints: 10, goldenPointEnabled: false)
        #expect(winner == .them)
    }
    
    // MARK: - Golden Point Rules
    
    @Test("Golden point: us wins at 4-3")
    func testGoldenPointUsWinsAtFourThree() {
        let winner = GameRules.gameWinner(usPoints: 4, themPoints: 3, goldenPointEnabled: true)
        #expect(winner == .us)
    }
    
    @Test("Golden point: them wins at 3-4")
    func testGoldenPointThemWinsAtThreeFour() {
        let winner = GameRules.gameWinner(usPoints: 3, themPoints: 4, goldenPointEnabled: true)
        #expect(winner == .them)
    }
    
    @Test("Golden point still requires 2-point lead when not at deuce", arguments: [
        (5, 4), (4, 5)
    ])
    func testGoldenPointStillRequiresTwoPointLeadWhenNotAtDeuce(usPoints: Int, themPoints: Int) {
        #expect(GameRules.gameWinner(usPoints: usPoints, themPoints: themPoints, goldenPointEnabled: true) == nil)
    }
    
    @Test("Golden point: no winner at 3-3")
    func testGoldenPointNoWinnerAtThreeThree() {
        let winner = GameRules.gameWinner(usPoints: 3, themPoints: 3, goldenPointEnabled: true)
        #expect(winner == nil)
    }
    
    @Test("Golden point: us wins with 2-point lead at 5-3")
    func testGoldenPointUsWinsWithTwoPointLead() {
        let winner = GameRules.gameWinner(usPoints: 5, themPoints: 3, goldenPointEnabled: true)
        #expect(winner == .us)
    }
    
    @Test("Golden point: them wins with 2-point lead at 3-5")
    func testGoldenPointThemWinsWithTwoPointLead() {
        let winner = GameRules.gameWinner(usPoints: 3, themPoints: 5, goldenPointEnabled: true)
        #expect(winner == .them)
    }
}
