//
//  ServeSelectionView.swift
//  CourtSide
//
//  Created by Kassim Mirza on 23/01/2026.
//


import SwiftUI

struct ServeSelectionView: View {
    let usColor: Color
    let themColor: Color
    let onSelectTeam: (Team) -> Void
    
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(spacing: 5) {
                    Text("Who Serves First?")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Select the team to serve")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .opacity(opacity)
                
                HStack(spacing: 20) {
                    // US Button
                    Button {
                        onSelectTeam(.us)
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "figure.tennis")
                                .font(.system(size: 30))
                            Text("US")
                                .font(.headline)
                        }
                        .frame(width: 70, height: 90)
                        .background(usColor.opacity(0.2))
                        .foregroundStyle(usColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(usColor, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // THEM Button
                    Button {
                        onSelectTeam(.them)
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "figure.tennis")
                                .font(.system(size: 30))
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            Text("THEM")
                                .font(.headline)
                        }
                        .frame(width: 70, height: 90)
                        .background(themColor.opacity(0.2))
                        .foregroundStyle(themColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(themColor, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .scaleEffect(scale)
                .opacity(opacity)
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    ServeSelectionView(
        usColor: .blue,
        themColor: .orange,
        onSelectTeam: { _ in }
    )
}
