//
//  SettingsButton.swift
//  CourtSide Watch App
//
//  Created by Kassim Mirza on 25/01/2026.
//

import SwiftUI

struct SettingsButton: View {
    let onSettings: () -> Void
    
    var body: some View {
        Button(action: onSettings) {
            Image(systemName: "gearshape")
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsButton(onSettings: {})
}
