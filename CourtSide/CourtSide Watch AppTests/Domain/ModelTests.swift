//
//  ModelTests.swift
//  CourtSide
//
//  Created by Kassim Mirza on 02/02/2026.
//

import Testing
@testable import CourtSide_Watch_App

@MainActor
@Suite("CourtSide Model Tests")
struct CourtSideTests {
    
    @Test("CourtSide toggles between deuce and advantage")
    func testCourtSideToggle() {
        var side = CourtSide.deuce
        side.toggle()
        #expect(side == .advantage)
        
        side.toggle()
        #expect(side == .deuce)
    }
}

@Suite("ServeState Tests")
struct ServeStateTests {
    
    @Test("Arrow direction when us is serving on deuce side")
    func testArrowForUsServingDeuce() {
        let serve = ServeState(servingTeam: .us, serverIndex: 0, side: .deuce)
        #expect(serve.arrow(for: .deuce) == "arrow.right")
        #expect(serve.arrow(for: .advantage) == "arrow.left")
    }
    
    @Test("Arrow direction when us is serving on advantage side")
    func testArrowForUsServingAdvantage() {
        let serve = ServeState(servingTeam: .us, serverIndex: 0, side: .advantage)
        #expect(serve.arrow(for: .deuce) == "arrow.right")
        #expect(serve.arrow(for: .advantage) == "arrow.left")
    }
    
    @Test("Arrow direction when them is serving on deuce side")
    func testArrowForThemServingDeuce() {
        let serve = ServeState(servingTeam: .them, serverIndex: 0, side: .deuce)
        #expect(serve.arrow(for: .deuce) == "arrow.left")
        #expect(serve.arrow(for: .advantage) == "arrow.right")
    }
    
    @Test("Arrow direction when them is serving on advantage side")
    func testArrowForThemServingAdvantage() {
        let serve = ServeState(servingTeam: .them, serverIndex: 0, side: .advantage)
        #expect(serve.arrow(for: .deuce) == "arrow.left")
        #expect(serve.arrow(for: .advantage) == "arrow.right")
    }
}

@Suite("Score Model Tests")
struct ScoreTests {
    
    @Test("SetScore initializes to zero")
    func testSetScoreInitialization() {
        let setScore = SetScore()
        #expect(setScore.us == 0)
        #expect(setScore.them == 0)
    }
    
    @Test("MatchScore initializes with one empty set")
    func testMatchScoreInitialization() {
        let matchScore = MatchScore()
        #expect(matchScore.sets.count == 1)
        #expect(matchScore.sets[0].us == 0)
        #expect(matchScore.sets[0].them == 0)
        #expect(matchScore.currentGame.us == 0)
        #expect(matchScore.currentGame.them == 0)
    }
}

@Suite("GamePoints Tests")
struct GamePointsTests {
    
    @Test("GamePoints initializes to zero")
    func testGamePointsInitialization() {
        let points = GamePoints()
        #expect(points.us == 0)
        #expect(points.them == 0)
    }
}
