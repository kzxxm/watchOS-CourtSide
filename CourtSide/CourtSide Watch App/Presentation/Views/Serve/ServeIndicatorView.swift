//
//  ServeIndicatorView.swift
//  CourtSide Watch App
//
//  Created by Kassim Mirza on 22/01/2026.
//

import SwiftUI

struct ServeIndicatorView: View {
    let serve: ServeState
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "figure.tennis")
                .font(.footnote)
                .frame(width: 10, height: 10)
                .opacity(0.7)
            
            Spacer()
                          
            Text(serve.servingTeam == .us ? "US" : "THEM")
            
            Image(systemName: serve.arrow(for: serve.side))
                .font(.body)
                .fontWeight(.bold)
                .contentTransition(.symbolEffect(.replace))
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
}

#Preview("Us, DEUCE") {
    let serve = ServeState(servingTeam: .us, serverIndex: 0, side: .deuce)
    ServeIndicatorView(serve: serve)
}

#Preview("Us, ADV") {
    let serve = ServeState(servingTeam: .us, serverIndex: 0, side: .advantage)
    ServeIndicatorView(serve: serve)
}

#Preview("Them, DEUCE") {
    let serve = ServeState(servingTeam: .them, serverIndex: 0, side: .deuce)
    ServeIndicatorView(serve: serve)
}

#Preview("Them, ADV") {
    let serve = ServeState(servingTeam: .them, serverIndex: 0, side: .advantage)
    ServeIndicatorView(serve: serve)
}
