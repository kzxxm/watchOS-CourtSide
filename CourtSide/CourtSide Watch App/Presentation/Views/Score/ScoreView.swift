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
    let match: MatchScore
    let serve: ServeState
    let swapPositions: Bool
    let goldenPointEnabled: Bool
    
    var body: some View {
        VStack(spacing: 10) {

            // Current game score tiles
            HStack(spacing: 12) {
                if swapPositions {
                    scoreTile(for: .them)
                    scoreTile(for: .us)
                } else {
                    scoreTile(for: .us)
                    scoreTile(for: .them)
                }
            }
            .rotation3DEffect(
                .degrees(swapPositions ? 360 : 0),
                axis: (x: -1, y: 0, z: 0)
            )
            .animation(.interactiveSpring(duration: 0.8), value: swapPositions)

        }
    }
    
    // MARK: - Helpers
    private func scoreTile(for team: Team) -> some View {
        VStack(spacing: 6) {
            Button {
                team == .us ? onUsPoint() : onThemPoint()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill((team == .us ? Color.blue : Color.orange).opacity(0.2))
                        .frame(height: 80)
                    
                    VStack {
                        HStack {
                            Text(team == .us ? "US" : "THEM")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundStyle(team == .us ? Color.blue : Color.orange)
                            
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Text("\(gameScore(for: team))")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .animation(.linear)
                        
                        Spacer()
                        Spacer()
                    }
                }
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            
                            if serve.servingTeam == team {
                                ServeIndicatorView(serve: serve)
                                    .padding(.top, 10)
                                    .padding(.trailing)
                            }
                        }
                        Spacer()
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private func gameScore(for team: Team) -> String {
        let usPoints = match.currentGame.us
        let themPoints = match.currentGame.them

        let points = team == .us ? usPoints : themPoints
        let opponent = team == .us ? themPoints : usPoints

        return ScoreFormatter
            .point(
                points: points,
                opponentPoints: opponent,
                goldenPointEnabled: goldenPointEnabled
            )
            .rawValue
    }
}

#Preview {
    ScoreView(
        onUsPoint: {},
        onThemPoint: {},
        onUndo: {},
        match: MatchScore(),
        serve: ServeState(servingTeam: .us, serverIndex: 0, side: .deuce),
        swapPositions: false,
        goldenPointEnabled: false
    )
}
