//
//  GameWinOverlay.swift
//  CourtSide
//
//  Created by Kassim Mirza on 23/01/2026.
//

import SwiftUI

struct GameWinOverlay: View {
    let winner: Team
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = -10
    
    var body: some View {
        ZStack {
            // Background with team color
            (winner == .us ? Color.blue : Color.orange)
                .ignoresSafeArea()
                .opacity(opacity * 0.95)
            
            // "GAME" text
            VStack(spacing: 20) {
                Text("GAME")
                    .font(.system(size: 60, weight: .black))
                    .foregroundStyle(.white)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                
                Text(winner == .us ? "WE WIN" : "THEY WIN")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.2
                rotation = 0
                opacity = 1
            }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                scale = 1.0
            }
        }
    }
}

#Preview("Home Win") {
    GameWinOverlay(
        winner: .us
    )
}

#Preview("Away Win") {
    GameWinOverlay(
        winner: .them
    )
}

