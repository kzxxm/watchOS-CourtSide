//
//  ColorThemePickerView.swift
//  CourtSide Watch App
//
//  Created by Kassim Mirza on 27/01/2026.
//

import SwiftUI

struct ColorThemePickerView: View {
    @Bindable var settings: MatchSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section {
                ForEach(TeamColor.allCases) { theme in
                    Button {
                        settings.applyTheme(theme)
                        dismiss()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(
                                    settings.selectedTheme == theme
                                    ? Color.gray.opacity(0.25)
                                    : Color.gray.opacity(0.15)
                                )
                            
                            HStack(spacing: 12) {
                                // Color circles
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(theme.team1Color)
                                        .frame(width: 20, height: 20)
                                    Circle()
                                        .fill(theme.team2Color)
                                        .frame(width: 20, height: 20)
                                }
                                .padding(.leading)
                                
                                Text(theme.name)
                                    .font(.body)
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                }
            } header: {
                Text("Team Color Selection")
            }
        }
    }
}

#Preview {
    ColorThemePickerView(settings: MatchSettings())
}
