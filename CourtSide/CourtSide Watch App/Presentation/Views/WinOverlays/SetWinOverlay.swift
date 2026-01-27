//
//  SetWinOverlay.swift
//  CourtSide Watch App
//
//  Created by Kassim Mirza on 23/01/2026.
//

import SwiftUI

struct SetWinOverlay: View {
    let usColor: Color
    let themColor: Color
    let winner: Team
    let onContinue: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = -10
    @State private var showSummary = false
    
    var body: some View {
//        if showSummary {
            
//        } else {
        if !showSummary {
            ZStack {
                // Background with team color
                (winner == .us ? Color.blue : Color.orange)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack {
                        Text("SET")
                            .font(.system(size: 70, weight: .black))
                            .foregroundStyle(.white)
                            .scaleEffect(scale)
                            .rotationEffect(.degrees(rotation))
                        
                        Text(winner == .us ? "WE WIN" : "THEY WIN")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                            .opacity(opacity)
                    }
                    
                    Button {
                        onContinue()
                    } label: {
                        Text("Next")
                            .font(.caption2)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .foregroundStyle(winner == .us ? Color.blue : Color.orange)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .opacity(opacity)
                }
                .padding(.bottom, 20)
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
}

#Preview {
    SetWinOverlay(usColor: .blue, themColor: .orange, winner: .us, onContinue: {})
}

#Preview {
    SetWinOverlay(usColor: .blue, themColor: .orange, winner: .them, onContinue: {})
}
