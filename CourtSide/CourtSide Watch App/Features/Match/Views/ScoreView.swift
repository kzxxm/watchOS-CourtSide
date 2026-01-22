//
//  ScoreView.swift
//  CourtSide Watch App
//
//  Created by Kassim Mirza on 22/01/2026.
//

import SwiftUI

struct ScoreView: View {
    let onUsPoint: () -> Void
    let onThemPoint: () -> Void
    let onUndo: () -> Void
    let score: MatchScore
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.2))
                    
                    Text("\(score.currentGame.us)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .onTapGesture(perform: onUsPoint)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.2))
                    
                    Text("\(score.currentGame.them)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .onTapGesture(perform: onThemPoint)
            }
            
            Button {
                onUndo()
            } label: {
                Text("Undo")
                    .font(.caption)
            }
            .tint(.red)
        }
    }
}

#Preview {
    ScoreView(
        onUsPoint: {},
        onThemPoint: {},
        onUndo: {},
        score: MatchScore()
    )
}
