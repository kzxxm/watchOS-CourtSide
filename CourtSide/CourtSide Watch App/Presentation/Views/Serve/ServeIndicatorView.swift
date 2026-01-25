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
        HStack {
//            Image(systemName: "figure.tennis")
            Image(systemName: serve.arrow(for: serve.side))
                .contentTransition(.symbolEffect(.replace))
        }
        .font(.system(size: 12))
        .opacity(0.7)
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
