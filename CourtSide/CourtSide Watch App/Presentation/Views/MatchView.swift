//
//  MatchView.swift
//  CourtSide Watch App
//
//  Created by Kassim Mirza on 22/01/2026.
//

import SwiftUI

struct MatchView: View {
    @State private var viewModel = MatchViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    SettingsButton(onSettings: viewModel.presentSettings )
                    Spacer()
                }
                
                SetScoreView(match: viewModel.match)
                
                ScoreView(
                    onUsPoint: { viewModel.pointWon(by: .us) },
                    onThemPoint: { viewModel.pointWon(by: .them) },
                    onUndo: { viewModel.undo() },
                    match: viewModel.match,
                    serve: viewModel.serve,
                    swapPositions: viewModel.swapPositions,
                    goldenPointEnabled: viewModel.settings.goldenPointEnabled,
                    usColor: viewModel.settings.team1Color,
                    themColor: viewModel.settings.team2Color
                )
                
                UndoResetButton(
                    onUndo: viewModel.undo,
                    onReset: viewModel.resetMatch,
                    canUndo: viewModel.canUndo
                )
            }
            
            // Auto-dismissing game win overlay
            if let gameWinner = viewModel.gameWinner {
                GameWinOverlay(
                    winner: gameWinner,
                    usColor: viewModel.settings.team1Color,
                    themColor: viewModel.settings.team2Color
                )
                    .transition(.opacity)
                    .zIndex(1)
                    .onTapGesture(perform: viewModel.dismissGameWinner)
            }
            
            // Serve selection overlay at start
            if viewModel.needsServeSelection {
                ServeSelectionView(
                    usColor: viewModel.settings.team1Color,
                    themColor: viewModel.settings.team2Color,
                ) { team in
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.selectInitialServer(team: team)
                    }
                }
                .transition(.opacity)
                .zIndex(2)
            }
        }
        // Manual-dismiss set win overlay
        .fullScreenCover(isPresented: Binding(
            get: { viewModel.setWinner != nil },
            set: { if !$0 { viewModel.dismissSetWinner() } }
        )) {
            if let winner = viewModel.setWinner {
                SetWinOverlay(
                    usColor: viewModel.settings.team1Color,
                    themColor: viewModel.settings.team2Color,
                    winner: winner
                ) {
                    viewModel.dismissSetWinner()
                }
            }
        }
        // Set summary sheet
        .sheet(isPresented: Binding(
            get: { viewModel.showSetSummary },
            set: { if !$0 { viewModel.dismissSetSummary() } }
        )) {
            SetSummaryView(
                completedSets: viewModel.completedSets,
                onContinue: viewModel.dismissSetSummary,
                usColor: viewModel.settings.team1Color,
                themColor: viewModel.settings.team2Color
            )
        }
        // Settings sheet
        .sheet(isPresented: Binding(
            get: { viewModel.showSettings },
            set: { _ in viewModel.dismissSettings() }
        )) {
            SettingsView(settings: viewModel.settings)
        }
    }
}

#Preview {
    MatchView()
}
