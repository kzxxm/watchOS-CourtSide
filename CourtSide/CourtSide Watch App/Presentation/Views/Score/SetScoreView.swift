//
//  SetScoreView.swift
//  CourtSide
//
//  Created by Kassim Mirza on 22/01/2026.
//

import SwiftUI

struct SetScoreView: View {
    let match: MatchScore
    
    var body: some View {
        Text("\(currentSet.us) - \(currentSet.them)")
            .font(.caption)
            .fontWeight(.semibold)
    }
    
    private var currentSet: SetScore {
        match.sets.last ?? SetScore()
    }
}

#Preview {
    SetScoreView(match: MatchScore())
}
