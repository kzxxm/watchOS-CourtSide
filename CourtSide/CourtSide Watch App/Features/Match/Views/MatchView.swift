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
                SetScoreView(match: viewModel.match)
                
                ScoreView(
                    onUsPoint: { viewModel.pointWon(by: .us) },
                    onThemPoint: { viewModel.pointWon(by: .them) },
                    onUndo: { viewModel.undo() },
                    match: viewModel.match,
                    swapPositions: viewModel.swapPositions
                )
                
                ServeIndicatorView(serve: viewModel.serve)
            }
            
            // Auto-dismissing game win overlay
            if let gameWinner = viewModel.gameWinner {
                GameWinOverlay(winner: gameWinner)
                    .transition(.opacity)
                    .zIndex(1)
                    .onTapGesture(perform: viewModel.dismissGameWinner)
            }
        }
        // Manual-dismiss set win overlay
        .fullScreenCover(isPresented: Binding(
            get: { viewModel.setWinner != nil },
            set: { if !$0 { viewModel.dismissSetWinner() } }
        )) {
            if let winner = viewModel.setWinner {
                SetWinOverlay(winner: winner) {
                    viewModel.dismissSetWinner()
                }
            }
        }
    }
}

#Preview {
    MatchView()
}
