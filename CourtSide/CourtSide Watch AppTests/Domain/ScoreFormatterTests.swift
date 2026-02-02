//
//  ScoreFormatterTests.swift
//  CourtSide
//
//  Created by Kassim Mirza on 02/02/2026.
//

import Testing
@testable import CourtSide_Watch_App

@Suite("Score Formatter Tests")
struct ScoreFormatterTests {
    
    // MARK: - Basic Point Conversion
    
    @Test("Point 0 formats as love")
    func testPointFormatsZeroAsLove() {
        let display = ScoreFormatter.point(points: 0, opponentPoints: 0, goldenPointEnabled: false)
        #expect(display == .love)
    }
    
    @Test("Point 1 formats as fifteen")
    func testPointFormatsOneAsFifteen() {
        let display = ScoreFormatter.point(points: 1, opponentPoints: 0, goldenPointEnabled: false)
        #expect(display == .fifteen)
    }
    
    @Test("Point 2 formats as thirty")
    func testPointFormatsTwoAsThirty() {
        let display = ScoreFormatter.point(points: 2, opponentPoints: 0, goldenPointEnabled: false)
        #expect(display == .thirty)
    }
    
    @Test("Point 3 formats as forty")
    func testPointFormatsThreeAsForty() {
        let display = ScoreFormatter.point(points: 3, opponentPoints: 0, goldenPointEnabled: false)
        #expect(display == .forty)
    }
    
    @Test("Point 4+ formats as forty when no deuce")
    func testPointFormatsFourOrMoreAsFortyWhenNoDeuce() {
        let display = ScoreFormatter.point(points: 4, opponentPoints: 0, goldenPointEnabled: false)
        #expect(display == .forty)
    }
    
    // MARK: - Deuce and Advantage Scenarios
    
    @Test("Deuce (3-3) shows forty for both players")
    func testDeuceShowsFortyForBothPlayers() {
        let usDisplay = ScoreFormatter.point(points: 3, opponentPoints: 3, goldenPointEnabled: false)
        let themDisplay = ScoreFormatter.point(points: 3, opponentPoints: 3, goldenPointEnabled: false)
        
        #expect(usDisplay == .forty)
        #expect(themDisplay == .forty)
    }
    
    @Test("Deuce at higher scores shows forty")
    func testDeuceAtHigherScores() {
        let display = ScoreFormatter.point(points: 10, opponentPoints: 10, goldenPointEnabled: false)
        #expect(display == .forty)
    }
    
    @Test("Advantage when leading after deuce")
    func testAdvantageWhenLeadingAfterDeuce() {
        let display = ScoreFormatter.point(points: 4, opponentPoints: 3, goldenPointEnabled: false)
        #expect(display == .advantage)
    }
    
    @Test("Forty when trailing after deuce")
    func testFortyWhenTrailingAfterDeuce() {
        let display = ScoreFormatter.point(points: 3, opponentPoints: 4, goldenPointEnabled: false)
        #expect(display == .forty)
    }
    
    @Test("Advantage at higher scores")
    func testAdvantageAtHigherScores() {
        let leadingDisplay = ScoreFormatter.point(points: 10, opponentPoints: 9, goldenPointEnabled: false)
        let trailingDisplay = ScoreFormatter.point(points: 9, opponentPoints: 10, goldenPointEnabled: false)
        
        #expect(leadingDisplay == .advantage)
        #expect(trailingDisplay == .forty)
    }
    
    // MARK: - Various Score Combinations
    
    @Test("All love-X score combinations", arguments: [
        (0, 0, DisplayPoint.love),
        (0, 1, DisplayPoint.love),
        (0, 2, DisplayPoint.love),
        (0, 3, DisplayPoint.love)
    ])
    func testLoveScoreCombinations(points: Int, opponentPoints: Int, expected: DisplayPoint) {
        #expect(ScoreFormatter.point(points: points, opponentPoints: opponentPoints, goldenPointEnabled: false) == expected)
    }
    
    @Test("All fifteen-X score combinations", arguments: [
        (1, 0, DisplayPoint.fifteen),
        (1, 1, DisplayPoint.fifteen),
        (1, 2, DisplayPoint.fifteen)
    ])
    func testFifteenScoreCombinations(points: Int, opponentPoints: Int, expected: DisplayPoint) {
        #expect(ScoreFormatter.point(points: points, opponentPoints: opponentPoints, goldenPointEnabled: false) == expected)
    }
    
    @Test("All thirty-X score combinations", arguments: [
        (2, 0, DisplayPoint.thirty),
        (2, 1, DisplayPoint.thirty),
        (2, 2, DisplayPoint.thirty)
    ])
    func testThirtyScoreCombinations(points: Int, opponentPoints: Int, expected: DisplayPoint) {
        #expect(ScoreFormatter.point(points: points, opponentPoints: opponentPoints, goldenPointEnabled: false) == expected)
    }
    
    @Test("All forty-X score combinations (before deuce)", arguments: [
        (3, 0, DisplayPoint.forty),
        (3, 1, DisplayPoint.forty),
        (3, 2, DisplayPoint.forty)
    ])
    func testFortyScoreCombinations(points: Int, opponentPoints: Int, expected: DisplayPoint) {
        #expect(ScoreFormatter.point(points: points, opponentPoints: opponentPoints, goldenPointEnabled: false) == expected)
    }
    
    // MARK: - Golden Point Testing
    
    @Test("Golden point does not affect basic scoring", arguments: [
        (0, 0, DisplayPoint.love),
        (1, 0, DisplayPoint.fifteen),
        (2, 1, DisplayPoint.thirty),
        (3, 2, DisplayPoint.forty)
    ])
    func testGoldenPointDoesNotAffectBasicScoring(points: Int, opponentPoints: Int, expected: DisplayPoint) {
        #expect(ScoreFormatter.point(points: points, opponentPoints: opponentPoints, goldenPointEnabled: true) == expected)
    }
    
    @Test("Golden point does not affect deuce display")
    func testGoldenPointDoesNotAffectDeuceDisplay() {
        let display = ScoreFormatter.point(points: 3, opponentPoints: 3, goldenPointEnabled: true)
        #expect(display == .forty)
    }
    
    @Test("Golden point does not affect advantage display")
    func testGoldenPointDoesNotAffectAdvantageDisplay() {
        let display = ScoreFormatter.point(points: 4, opponentPoints: 3, goldenPointEnabled: true)
        #expect(display == .advantage)
    }
    
    // MARK: - Edge Cases
    
    @Test("Very high scores show advantage correctly")
    func testVeryHighScores() {
        let display = ScoreFormatter.point(points: 20, opponentPoints: 18, goldenPointEnabled: false)
        #expect(display == .advantage)
    }
    
    @Test("Score with large gap shows forty")
    func testScoreWithLargeGap() {
        // Even if one player has many points, if opponent is below 3, normal rules apply
        let display = ScoreFormatter.point(points: 10, opponentPoints: 2, goldenPointEnabled: false)
        #expect(display == .forty)
    }
}
