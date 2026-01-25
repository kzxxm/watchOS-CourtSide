//
//  SetSummaryView.swift
//  CourtSide
//
//  Created by Kassim Mirza on 23/01/2026.
//


import SwiftUI

struct SetSummaryView: View {
    let completedSets: [SetScore]
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Text("Set Summary")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                VStack(spacing: 16) {
                    ForEach(Array(completedSets.enumerated()), id: \.offset) { index, set in
                        SetSummaryCard(setNumber: index + 1, set: set)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                Button {
                    onContinue()
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.horizontal)
            }
        }
    }
}

struct SetSummaryCard: View {
    let setNumber: Int
    let set: SetScore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Set \(setNumber)")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack {
                HStack {
                    Text("US")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("THEM")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("\(set.us)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.blue)
                    
                    Spacer()
                    
                    Text("-")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(set.them)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.orange)
                }
            }
            
            // Winner indicator
            if set.us > set.them {
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(.blue)
                    Text("WE Won")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            } else if set.them > set.us {
                HStack {
                    Spacer()
                    Text("THEY Won")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding()
        .padding(.horizontal)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SetSummaryView(
        completedSets: {
            let m = [
                SetScore(us: 6, them: 2),
                SetScore(us: 4, them: 6)
            ]
            return m
        }(),
        onContinue: {}
    )
}
