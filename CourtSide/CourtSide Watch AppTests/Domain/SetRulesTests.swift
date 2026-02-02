//
//  SetRulesTests.swift
//  CourtSide
//
//  Created by Kassim Mirza on 02/02/2026.
//

import Testing
@testable import CourtSide_Watch_App

@MainActor
@Suite("Set Rules Tests")
struct SetRulesTests {
    
    // MARK: - Standard Set Rules
    
    @Test("No winner when score is 0-0")
    func testNoWinnerWhenScoreIsZeroZero() {
        let winner = SetRules.setWinner(usGames: 0, themGames: 0, tieBreakEnabled: false)
        #expect(winner == nil)
    }
    
    @Test("No winner when both players are below 6 games", arguments: [
        (5, 4), (4, 5), (5, 5)
    ])
    func testNoWinnerWhenBothBelowSix(usGames: Int, themGames: Int) {
        #expect(SetRules.setWinner(usGames: usGames, themGames: themGames, tieBreakEnabled: false) == nil)
    }
    
    @Test("Us wins with 6-0")
    func testUsWinsWithSixToZero() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 0, tieBreakEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Us wins with 6-1")
    func testUsWinsWithSixToOne() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 1, tieBreakEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Us wins with 6-2")
    func testUsWinsWithSixToTwo() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 2, tieBreakEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Us wins with 6-3")
    func testUsWinsWithSixToThree() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 3, tieBreakEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Us wins with 6-4")
    func testUsWinsWithSixToFour() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 4, tieBreakEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Them wins with 6-0")
    func testThemWinsWithSixToZero() {
        let winner = SetRules.setWinner(usGames: 0, themGames: 6, tieBreakEnabled: false)
        #expect(winner == .them)
    }
    
    @Test("Them wins with 6-4")
    func testThemWinsWithSixToFour() {
        let winner = SetRules.setWinner(usGames: 4, themGames: 6, tieBreakEnabled: false)
        #expect(winner == .them)
    }
    
    // MARK: - Close Games (5-5, 6-5, etc.)
    
    @Test("No winner at 6-5", arguments: [
        (6, 5), (5, 6)
    ])
    func testNoWinnerAtSixToFive(usGames: Int, themGames: Int) {
        #expect(SetRules.setWinner(usGames: usGames, themGames: themGames, tieBreakEnabled: false) == nil)
    }
    
    @Test("No winner at 6-6")
    func testNoWinnerAtSixToSix() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 6, tieBreakEnabled: false)
        #expect(winner == nil)
    }
    
    @Test("Us wins with 7-5")
    func testUsWinsWithSevenToFive() {
        let winner = SetRules.setWinner(usGames: 7, themGames: 5, tieBreakEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Them wins with 7-5")
    func testThemWinsWithSevenToFive() {
        let winner = SetRules.setWinner(usGames: 5, themGames: 7, tieBreakEnabled: false)
        #expect(winner == .them)
    }
    
    @Test("No winner at 7-6", arguments: [
        (7, 6), (6, 7)
    ])
    func testNoWinnerAtSevenToSix(usGames: Int, themGames: Int) {
        #expect(SetRules.setWinner(usGames: usGames, themGames: themGames, tieBreakEnabled: false) == nil)
    }
    
    @Test("Us wins with 8-6")
    func testUsWinsWithEightToSix() {
        let winner = SetRules.setWinner(usGames: 8, themGames: 6, tieBreakEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Them wins with 8-6")
    func testThemWinsWithEightToSix() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 8, tieBreakEnabled: false)
        #expect(winner == .them)
    }
    
    @Test("Us wins at high score (12-10)")
    func testUsWinsAtHighScore() {
        let winner = SetRules.setWinner(usGames: 12, themGames: 10, tieBreakEnabled: false)
        #expect(winner == .us)
    }
    
    @Test("Them wins at high score (12-10)")
    func testThemWinsAtHighScore() {
        let winner = SetRules.setWinner(usGames: 10, themGames: 12, tieBreakEnabled: false)
        #expect(winner == .them)
    }
    
    // MARK: - Tie-break Rules
    
    @Test("Tie-break: us wins at 7-6")
    func testTieBreakUsWinsAtSevenToSix() {
        let winner = SetRules.setWinner(usGames: 7, themGames: 6, tieBreakEnabled: true)
        #expect(winner == .us)
    }
    
    @Test("Tie-break: them wins at 7-6")
    func testTieBreakThemWinsAtSevenToSix() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 7, tieBreakEnabled: true)
        #expect(winner == .them)
    }
    
    @Test("Tie-break: no winner at 6-6")
    func testTieBreakNoWinnerAtSixToSix() {
        let winner = SetRules.setWinner(usGames: 6, themGames: 6, tieBreakEnabled: true)
        #expect(winner == nil)
    }
    
    @Test("Tie-break: standard wins work", arguments: [
        (6, 4, Team.us),
        (6, 3, Team.us),
        (4, 6, Team.them),
        (3, 6, Team.them)
    ])
    func testTieBreakStandardWinsStillWork(usGames: Int, themGames: Int, expectedWinner: Team) {
        #expect(SetRules.setWinner(usGames: usGames, themGames: themGames, tieBreakEnabled: true) == expectedWinner)
    }
}
