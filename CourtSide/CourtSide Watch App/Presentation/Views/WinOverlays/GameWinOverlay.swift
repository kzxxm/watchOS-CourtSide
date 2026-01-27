//
//  GameWinOverlay.swift
//  CourtSide
//
//  Created by Kassim Mirza on 23/01/2026.
//

import SwiftUI

struct GameWinOverlay: View {
    let winner: Team
    let usColor: Color
    let themColor: Color
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = -10
    
    var body: some View {
        ZStack {
            // Background with team color
            (winner == .us ? usColor : themColor)
                .ignoresSafeArea()
                .opacity(opacity * 0.95)
            
            // "GAME" text
            VStack(spacing: 0) {
                Text("GAME")
                    .font(.system(size: 40, weight: .black))
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
        winner: .us,
        usColor: .blue,
        themColor: .orange
    )
}

#Preview("Away Win") {
    GameWinOverlay(
        winner: .them,
        usColor: .blue,
        themColor: .orange
    )
}

