//
//  ServeRulesTests.swift
//  CourtSide
//
//  Created by Kassim Mirza on 02/02/2026.
//

import Testing
@testable import CourtSide_Watch_App

@MainActor
@Suite("Serve Rules Tests")
struct ServeRulesTests {
    
    // MARK: - Next Side Tests
    
    @Test("Next side from deuce is advantage")
    func testNextSideFromDeuce() {
        let nextSide = ServeRules.nextSide(current: .deuce)
        #expect(nextSide == .advantage)
    }
    
    @Test("Next side from advantage is deuce")
    func testNextSideFromAdvantage() {
        let nextSide = ServeRules.nextSide(current: .advantage)
        #expect(nextSide == .deuce)
    }
    
    @Test("Next side toggles correctly in sequence")
    func testNextSideTogglesCorrectly() {
        var side = CourtSide.deuce
        side = ServeRules.nextSide(current: side)
        #expect(side == .advantage)
        
        side = ServeRules.nextSide(current: side)
        #expect(side == .deuce)
        
        side = ServeRules.nextSide(current: side)
        #expect(side == .advantage)
    }
    
    // MARK: - Next Server Tests
    
    @Test("Next server switches from us to them")
    func testNextServerSwitchesFromUsToThem() {
        let currentServe = ServeState(servingTeam: .us, serverIndex: 0, side: .deuce)
        let nextServe = ServeRules.nextServer(afterGame: currentServe)
        
        #expect(nextServe.servingTeam == .them)
        #expect(nextServe.serverIndex == 0)
        #expect(nextServe.side == .deuce)
    }
    
    @Test("Next server switches from them to us")
    func testNextServerSwitchesFromThemToUs() {
        let currentServe = ServeState(servingTeam: .them, serverIndex: 0, side: .advantage)
        let nextServe = ServeRules.nextServer(afterGame: currentServe)
        
        #expect(nextServe.servingTeam == .us)
        #expect(nextServe.serverIndex == 0)
        #expect(nextServe.side == .deuce)
    }
    
    @Test("Next server resets server index to 0")
    func testNextServerResetsServerIndex() {
        let currentServe = ServeState(servingTeam: .us, serverIndex: 1, side: .advantage)
        let nextServe = ServeRules.nextServer(afterGame: currentServe)
        
        #expect(nextServe.serverIndex == 0)
    }
    
    @Test("Next server resets side to deuce")
    func testNextServerResetsSideToDeuce() {
        let currentServe = ServeState(servingTeam: .them, serverIndex: 0, side: .advantage)
        let nextServe = ServeRules.nextServer(afterGame: currentServe)
        
        #expect(nextServe.side == .deuce)
    }
    
    @Test("Next server alternates correctly in sequence")
    func testNextServerAlternatesCorrectly() {
        var currentServe = ServeState(servingTeam: .us, serverIndex: 0, side: .deuce)
        
        currentServe = ServeRules.nextServer(afterGame: currentServe)
        #expect(currentServe.servingTeam == .them)
        
        currentServe = ServeRules.nextServer(afterGame: currentServe)
        #expect(currentServe.servingTeam == .us)
        
        currentServe = ServeRules.nextServer(afterGame: currentServe)
        #expect(currentServe.servingTeam == .them)
    }
}
