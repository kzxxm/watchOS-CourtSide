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
    }
}

#Preview {
    MatchView()
}
