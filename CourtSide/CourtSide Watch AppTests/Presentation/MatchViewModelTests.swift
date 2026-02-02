//
//  MatchViewModelTests.swift
//  CourtSide
//
//  Created by Kassim Mirza on 02/02/2026.
//

import Testing
@testable import CourtSide_Watch_App

@Suite("Match ViewModel Tests")
struct MatchViewModelTests {
    
    // MARK: - Initialization
    
    @Test("Default initialization creates correct state")
    func testDefaultInitialization() {
        let viewModel = MatchViewModel()
        
        #expect(viewModel.match.sets.count == 1)
        #expect(viewModel.match.currentGame.us == 0)
        #expect(viewModel.match.currentGame.them == 0)
        #expect(viewModel.serve.servingTeam == .us)
        #expect(viewModel.gameWinner == nil)
        #expect(viewModel.setWinner == nil)
        #expect(viewModel.needsServeSelection == true)
        #expect(viewModel.canUndo == false)
    }
    
    // MARK: - Initial Server Selection
    
    @Test("Select initial server us sets correct state")
    func testSelectInitialServerUs() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        #expect(viewModel.serve.servingTeam == .us)
        #expect(viewModel.serve.serverIndex == 0)
        #expect(viewModel.serve.side == .deuce)
        #expect(viewModel.swapPositions == false)
        #expect(viewModel.needsServeSelection == false)
    }
    
    @Test("Select initial server them sets correct state")
    func testSelectInitialServerThem() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .them)
        
        #expect(viewModel.serve.servingTeam == .them)
        #expect(viewModel.serve.serverIndex == 0)
        #expect(viewModel.serve.side == .deuce)
        #expect(viewModel.swapPositions == true)
        #expect(viewModel.needsServeSelection == false)
    }
    
    // MARK: - Point Scoring
    
    @Test("Point won by us increments score")
    func testPointWonByUs() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        viewModel.pointWon(by: .us)
        
        #expect(viewModel.match.currentGame.us == 1)
        #expect(viewModel.match.currentGame.them == 0)
        #expect(viewModel.canUndo == true)
    }
    
    @Test("Point won by them increments score")
    func testPointWonByThem() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        viewModel.pointWon(by: .them)
        
        #expect(viewModel.match.currentGame.us == 0)
        #expect(viewModel.match.currentGame.them == 1)
        #expect(viewModel.canUndo == true)
    }
    
    @Test("Serve side toggles after each point")
    func testServeSideTogglesAfterEachPoint() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        #expect(viewModel.serve.side == .deuce)
        
        viewModel.pointWon(by: .us)
        #expect(viewModel.serve.side == .advantage)
        
        viewModel.pointWon(by: .us)
        #expect(viewModel.serve.side == .deuce)
        
        viewModel.pointWon(by: .them)
        #expect(viewModel.serve.side == .advantage)
    }
    
    // MARK: - Game Winning
    
    @Test("Game won by us after 4 points")
    func testGameWonByUs() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        // Score 4 points for us
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .us)
        
        // Check game was won
        let currentSet = viewModel.match.sets[0]
        #expect(currentSet.us == 1)
        #expect(currentSet.them == 0)
        
        // Game points should reset
        #expect(viewModel.match.currentGame.us == 0)
        #expect(viewModel.match.currentGame.them == 0)
        
        // Server should switch
        #expect(viewModel.serve.servingTeam == .them)
        #expect(viewModel.swapPositions == true)
    }
    
    @Test("Game won by them after 4 points")
    func testGameWonByThem() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        // Score 4 points for them
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .them)
        
        let currentSet = viewModel.match.sets[0]
        #expect(currentSet.us == 0)
        #expect(currentSet.them == 1)
        #expect(viewModel.serve.servingTeam == .them)
    }
    
    @Test("Game with deuce requires 2-point advantage")
    func testGameWithDeuce() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        viewModel.settings.goldenPointEnabled = false
        
        // Get to deuce (3-3)
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .them)
        
        #expect(viewModel.match.currentGame.us == 3)
        #expect(viewModel.match.currentGame.them == 3)
        
        // Need 2 point advantage to win
        viewModel.pointWon(by: .us) // 4-3
        #expect(viewModel.match.currentGame.us == 4)
        #expect(viewModel.match.sets[0].us == 0) // Game not won yet
        
        viewModel.pointWon(by: .us) // 5-3
        #expect(viewModel.match.sets[0].us == 1) // Now game is won
        #expect(viewModel.match.currentGame.us == 0) // Points reset
    }
    
    // MARK: - Golden Point
    
    @Test("Golden point enabled wins at 4-3")
    func testGoldenPointEnabled() {
        let settings = MatchSettings()
        settings.goldenPointEnabled = true
        let viewModel = MatchViewModel(settings: settings)
        viewModel.selectInitialServer(team: .us)
        
        // Get to 3-3 (deuce)
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .them)
        
        // Next point wins with golden point
        viewModel.pointWon(by: .us) // 4-3 wins immediately
        #expect(viewModel.match.sets[0].us == 1)
        #expect(viewModel.match.currentGame.us == 0)
    }
    
    // MARK: - Set Winning
    
    @Test("Set won by us after 6 games")
    func testSetWonByUs() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        // Win 6 games
        for _ in 0..<6 {
            for _ in 0..<4 {
                viewModel.pointWon(by: .us)
            }
        }
        
        #expect(viewModel.match.sets.count == 2) // New set started
        #expect(viewModel.match.sets[0].us == 6)
        #expect(viewModel.match.sets[0].them == 0)
    }
    
    @Test("Set requires 2-game lead")
    func testSetRequiresTwoGameLead() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        // Get to 5-5
        for _ in 0..<5 {
            for _ in 0..<4 {
                viewModel.pointWon(by: .us)
            }
            for _ in 0..<4 {
                viewModel.pointWon(by: .them)
            }
        }
        
        // Win one more game (6-5)
        for _ in 0..<4 {
            viewModel.pointWon(by: .us)
        }
        
        #expect(viewModel.match.sets.count == 1) // Set not won yet
        #expect(viewModel.match.sets[0].us == 6)
        #expect(viewModel.match.sets[0].them == 5)
        
        // Win another game (7-5)
        for _ in 0..<4 {
            viewModel.pointWon(by: .us)
        }
        
        #expect(viewModel.match.sets.count == 2) // Set won
        #expect(viewModel.match.sets[0].us == 7)
        #expect(viewModel.match.sets[0].them == 5)
    }
    
    // MARK: - Undo Functionality
    
    @Test("Undo single point restores previous state")
    func testUndoSinglePoint() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        viewModel.pointWon(by: .us)
        
        #expect(viewModel.match.currentGame.us == 1)
        #expect(viewModel.canUndo == true)
        
        viewModel.undo()
        
        #expect(viewModel.match.currentGame.us == 0)
        #expect(viewModel.canUndo == false)
    }
    
    @Test("Undo multiple points works correctly")
    func testUndoMultiplePoints() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .us)
        
        #expect(viewModel.match.currentGame.us == 2)
        #expect(viewModel.match.currentGame.them == 1)
        
        viewModel.undo()
        #expect(viewModel.match.currentGame.us == 1)
        #expect(viewModel.match.currentGame.them == 1)
        
        viewModel.undo()
        #expect(viewModel.match.currentGame.us == 1)
        #expect(viewModel.match.currentGame.them == 0)
        
        viewModel.undo()
        #expect(viewModel.match.currentGame.us == 0)
        #expect(viewModel.match.currentGame.them == 0)
    }
    
    @Test("Undo restores serve state")
    func testUndoRestoresServeState() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        #expect(viewModel.serve.side == .deuce)
        
        viewModel.pointWon(by: .us)
        #expect(viewModel.serve.side == .advantage)
        
        viewModel.undo()
        #expect(viewModel.serve.side == .deuce)
    }
    
    @Test("Cannot undo when history is empty")
    func testCannotUndoWhenHistoryEmpty() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        #expect(viewModel.canUndo == false)
        
        viewModel.undo()
        // Should not crash
        
        #expect(viewModel.canUndo == false)
    }
    
    // MARK: - Reset Match
    
    @Test("Reset match returns to initial state")
    func testResetMatch() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        // Play some points
        viewModel.pointWon(by: .us)
        viewModel.pointWon(by: .them)
        viewModel.pointWon(by: .us)
        
        viewModel.resetMatch()
        
        #expect(viewModel.match.sets.count == 1)
        #expect(viewModel.match.currentGame.us == 0)
        #expect(viewModel.match.currentGame.them == 0)
        #expect(viewModel.serve.servingTeam == .us)
        #expect(viewModel.canUndo == false)
        #expect(viewModel.swapPositions == false)
        #expect(viewModel.needsServeSelection == true)
    }
    
    // MARK: - Completed Sets
    
    @Test("Completed set")
    func testCompletedSetsExcludesCurrentSet() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        // Initial state - current set is empty
        #expect(viewModel.completedSets.count == 0)
        
        // Win all sets
        for _ in 0..<6 {
            for _ in 0..<4 {
                viewModel.pointWon(by: .us)
            }
        }
        
        // Now we have one completed set
        #expect(viewModel.completedSets.count == 1)
        #expect(viewModel.completedSets[0].us == 6)
        #expect(viewModel.completedSets[0].them == 0)
    }
    
    // MARK: - Settings and Presentation
    
    @Test("Present and dismiss settings works")
    func testPresentAndDismissSettings() {
        let viewModel = MatchViewModel()
        #expect(viewModel.showSettings == false)
        
        viewModel.presentSettings()
        #expect(viewModel.showSettings == true)
        
        viewModel.dismissSettings()
        #expect(viewModel.showSettings == false)
    }
    
    @Test("Dismiss set summary updates state")
    func testDismissSetSummary() {
        let viewModel = MatchViewModel()
        viewModel.dismissSetSummary()
        #expect(viewModel.showSetSummary == false)
        #expect(viewModel.needsServeSelection == true)
    }
    
    // MARK: - Server Rotation
    
    @Test("Server rotates after each game")
    func testServerRotatesAfterEachGame() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        
        #expect(viewModel.serve.servingTeam == .us)
        #expect(viewModel.swapPositions == false)
        
        // Win game 1
        for _ in 0..<4 {
            viewModel.pointWon(by: .us)
        }
        
        #expect(viewModel.serve.servingTeam == .them)
        #expect(viewModel.swapPositions == true)
        
        // Win game 2
        for _ in 0..<4 {
            viewModel.pointWon(by: .us)
        }
        
        #expect(viewModel.serve.servingTeam == .us)
        #expect(viewModel.swapPositions == false)
    }
    
    // MARK: - Complex Game Scenarios
    
    @Test("Complete match scenario with deuce and advantage")
    func testCompleteMatchScenario() {
        let viewModel = MatchViewModel()
        viewModel.selectInitialServer(team: .us)
        viewModel.settings.goldenPointEnabled = false
        
        // Play a close game with deuce
        viewModel.pointWon(by: .us)    // 15-0
        viewModel.pointWon(by: .them)  // 15-15
        viewModel.pointWon(by: .us)    // 30-15
        viewModel.pointWon(by: .them)  // 30-30
        viewModel.pointWon(by: .us)    // 40-30
        viewModel.pointWon(by: .them)  // Deuce (40-40)
        
        #expect(viewModel.match.currentGame.us == 3)
        #expect(viewModel.match.currentGame.them == 3)
        
        viewModel.pointWon(by: .us)    // Advantage us
        #expect(viewModel.match.currentGame.us == 4)
        #expect(viewModel.match.sets[0].us == 0) // Game not won yet
        
        viewModel.pointWon(by: .them)  // Back to deuce
        #expect(viewModel.match.currentGame.us == 4)
        #expect(viewModel.match.currentGame.them == 4)
        
        viewModel.pointWon(by: .us)    // Advantage us again
        viewModel.pointWon(by: .us)    // Game won
        
        #expect(viewModel.match.sets[0].us == 1)
        #expect(viewModel.match.currentGame.us == 0)
        #expect(viewModel.serve.servingTeam == .them)
    }
}
