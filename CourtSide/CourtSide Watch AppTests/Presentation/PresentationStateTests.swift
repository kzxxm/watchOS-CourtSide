//
//  PresentationStateTests.swift
//  CourtSide
//
//  Created by Kassim Mirza on 02/02/2026.
//

import Testing
@testable import CourtSide_Watch_App

@MainActor
@Suite("Presentation State Tests")
struct PresentationStateTests {
    
    // MARK: - Initialization
    
    @Test("Default initialization creates correct initial state")
    func testDefaultInitialization() {
        let state = PresentationState()
        
        #expect(state.gameWinner == nil)
        #expect(state.setWinner == nil)
        #expect(state.showSetSummary == false)
        #expect(state.needsServeSelection == true)
        #expect(state.showSettings == false)
    }
    
    @Test("Custom initialization preserves values")
    func testCustomInitialization() {
        let state = PresentationState(
            gameWinner: .us,
            setWinner: .them,
            showSetSummary: true,
            needsServeSelection: false,
            showSettings: true
        )
        
        #expect(state.gameWinner == .us)
        #expect(state.setWinner == .them)
        #expect(state.showSetSummary == true)
        #expect(state.needsServeSelection == false)
        #expect(state.showSettings == true)
    }
    
    // MARK: - Game Winner Management
    
    @Test("Dismiss game winner clears winner")
    func testDismissGameWinner() {
        var state = PresentationState(gameWinner: .us)
        #expect(state.gameWinner == .us)
        
        state.dismissGameWinner()
        #expect(state.gameWinner == nil)
    }
    
    @Test("Dismiss game winner when nil has no effect")
    func testDismissGameWinnerWhenNil() {
        var state = PresentationState()
        #expect(state.gameWinner == nil)
        
        state.dismissGameWinner()
        #expect(state.gameWinner == nil)
    }
    
    // MARK: - Set Winner Management
    
    @Test("Show set winner sets the winner", arguments: [Team.us, Team.them])
    func testShowSetWinner(team: Team) {
        var state = PresentationState()
        #expect(state.setWinner == nil)
        
        state.showSetWinner(team)
        #expect(state.setWinner == team)
    }
    
    @Test("Dismiss set winner clears winner and shows summary")
    func testDismissSetWinner() {
        var state = PresentationState(setWinner: .them)
        #expect(state.setWinner == .them)
        #expect(state.showSetSummary == false)
        
        state.dismissSetWinner()
        
        #expect(state.setWinner == nil)
        #expect(state.showSetSummary == true)
    }
    
    @Test("Dismiss set winner enables set summary")
    func testDismissSetWinnerEnablesSetSummary() {
        var state = PresentationState(setWinner: .us, showSetSummary: false)
        
        state.dismissSetWinner()
        
        #expect(state.showSetSummary == true)
    }
    
    // MARK: - Set Summary Management
    
    @Test("Dismiss set summary hides summary and enables serve selection")
    func testDismissSetSummary() {
        var state = PresentationState(showSetSummary: true, needsServeSelection: false)
        
        state.dismissSetSummary()
        
        #expect(state.showSetSummary == false)
        #expect(state.needsServeSelection == true)
    }
    
    @Test("Dismiss set summary enables serve selection")
    func testDismissSetSummaryEnablesServeSelection() {
        var state = PresentationState(showSetSummary: true, needsServeSelection: false)
        
        state.dismissSetSummary()
        
        #expect(state.needsServeSelection == true)
    }
    
    // MARK: - Serve Selection Management
    
    @Test("Complete serve selection disables need for selection")
    func testCompleteServeSelection() {
        var state = PresentationState(needsServeSelection: true)
        
        state.completeServeSelection()
        
        #expect(state.needsServeSelection == false)
    }
    
    @Test("Complete serve selection when already completed has no effect")
    func testCompleteServeSelectionWhenAlreadyCompleted() {
        var state = PresentationState(needsServeSelection: false)
        
        state.completeServeSelection()
        
        #expect(state.needsServeSelection == false)
    }
    
    // MARK: - Settings Management
    
    @Test("Present settings shows settings")
    func testPresentSettings() {
        var state = PresentationState(showSettings: false)
        
        state.presentSettings()
        
        #expect(state.showSettings == true)
    }
    
    @Test("Dismiss settings hides settings")
    func testDismissSettings() {
        var state = PresentationState(showSettings: true)
        
        state.dismissSettings()
        
        #expect(state.showSettings == false)
    }
    
    // MARK: - State Flow Scenarios
    
    @Test("Complete game win to set win flow")
    func testGameWinToSetWinFlow() {
        var state = PresentationState()
        
        // Show game winner
        state.gameWinner = .us
        #expect(state.gameWinner == .us)
        #expect(state.setWinner == nil)
        
        // Dismiss game winner
        state.dismissGameWinner()
        #expect(state.gameWinner == nil)
        
        // Show set winner
        state.showSetWinner(.us)
        #expect(state.setWinner == .us)
        #expect(state.showSetSummary == false)
        
        // Dismiss set winner (triggers set summary)
        state.dismissSetWinner()
        #expect(state.setWinner == nil)
        #expect(state.showSetSummary == true)
        
        // Dismiss set summary (triggers serve selection)
        state.dismissSetSummary()
        #expect(state.showSetSummary == false)
        #expect(state.needsServeSelection == true)
    }
    
    @Test("Serve selection flow after set win")
    func testServeSelectionFlow() {
        var state = PresentationState()
        
        // Starts needing serve selection
        #expect(state.needsServeSelection == true)
        
        // Complete selection
        state.completeServeSelection()
        #expect(state.needsServeSelection == false)
        
        // After set win flow, serve selection is needed again
        state.showSetWinner(.them)
        state.dismissSetWinner()
        state.dismissSetSummary()
        
        #expect(state.needsServeSelection == true)
    }
    
    @Test("Settings do not interfere with game flow")
    func testSettingsDoNotInterfereWithGameFlow() {
        var state = PresentationState(gameWinner: .us, setWinner: .them)
        
        state.presentSettings()
        
        #expect(state.showSettings == true)
        #expect(state.gameWinner == .us)
        #expect(state.setWinner == .them)
        
        state.dismissSettings()
        
        #expect(state.showSettings == false)
        #expect(state.gameWinner == .us)
        #expect(state.setWinner == .them)
    }
    
    @Test("Multiple state changes work correctly")
    func testMultipleStateChanges() {
        var state = PresentationState()
        
        state.presentSettings()
        #expect(state.showSettings == true)
        
        state.dismissSettings()
        #expect(state.showSettings == false)
        
        state.completeServeSelection()
        #expect(state.needsServeSelection == false)
        
        state.showSetWinner(.us)
        #expect(state.setWinner == .us)
        
        state.dismissSetWinner()
        #expect(state.setWinner == nil)
        #expect(state.showSetSummary == true)
        
        state.dismissSetSummary()
        #expect(state.showSetSummary == false)
        #expect(state.needsServeSelection == true)
    }
}
