//
//  ServeSelectionView.swift
//  CourtSide
//
//  Created by Kassim Mirza on 23/01/2026.
//


import SwiftUI

struct ServeSelectionView: View {
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
                        .background(Color.blue.opacity(0.2))
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.blue, lineWidth: 2)
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
                        .background(Color.orange.opacity(0.2))
                        .foregroundStyle(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange, lineWidth: 2)
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
    ServeSelectionView { team in
        print("Selected: \(team)")
    }
}
