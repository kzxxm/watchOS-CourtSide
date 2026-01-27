//
//  SettingsView.swift
//  CourtSide
//
//  Created by Kassim Mirza on 25/01/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var settings: MatchSettings
    @State private var showColorPicker = false
    
    var body: some View {
        Form {
            Section {
                Button {
                    showColorPicker = true
                } label: {
                    HStack {
                        Text("Team Colors")
                        
                        Spacer()
                        
                        Circle()
                            .fill(settings.selectedTheme.team1Color)
                            .frame(width: 18, height: 18)
                        
                        Circle()
                            .fill(settings.selectedTheme.team2Color)
                            .frame(width: 18, height: 18)
                    }
                }
            } header: {
                Text("Team Colors")
            }
            
            Section {
                Toggle("Golden Point", isOn: $settings.goldenPointEnabled)
                Toggle("Tie Break", isOn: $settings.tieBreakEnabled)
            } header: {
                Text("Match Rules")
                    .padding(.vertical, 2)
            } footer: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("**Golden Point:**  When enabled, deuce games are decided by a single decisive point instead of requiring a 2-point advantage.")
                    Text("**Tie Break:**  When enabled, sets can be won with tie-breaks at 6-6.")
                }
                .padding(.vertical)
            }
        }
        .sheet(isPresented: $showColorPicker) {
            ColorThemePickerView(settings: settings)
        }
    }
}

#Preview {
    SettingsView(settings: MatchSettings())
}
