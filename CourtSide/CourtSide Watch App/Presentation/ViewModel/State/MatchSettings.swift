//
//  MatchSettings.swift
//  CourtSide
//
//  Created by Kassim Mirza on 28/01/2026.
//

import Observation
import SwiftUI

// MARK: - Match Settings

@Observable
final class MatchSettings {
    @ObservationIgnored
    @AppStorage(DefaultsKey.goldenPointEnabled.rawValue) var goldenPointEnabled = false
    
    @ObservationIgnored
    @AppStorage(DefaultsKey.tieBreakEnabled.rawValue) var tieBreakEnabled = false
    
    @ObservationIgnored
    @AppStorage(DefaultsKey.team1Color.rawValue) private var _team1Color = Color.blue
    
    @ObservationIgnored
    @AppStorage(DefaultsKey.team2Color.rawValue) private var _team2Color = Color.orange
    
    @ObservationIgnored
    @AppStorage(DefaultsKey.selectedTheme.rawValue) private var _selectedThemeRawValue = TeamColor.blueOrange.rawValue
    
    // Observable properties that manually trigger updates
    var team1Color: Color {
        get {
            access(keyPath: \.team1Color)
            return _team1Color
        }
        set {
            withMutation(keyPath: \.team1Color) {
                _team1Color = newValue
            }
        }
    }
    
    var team2Color: Color {
        get {
            access(keyPath: \.team2Color)
            return _team2Color
        }
        set {
            withMutation(keyPath: \.team2Color) {
                _team2Color = newValue
            }
        }
    }
    
    var selectedTheme: TeamColor {
        get {
            access(keyPath: \.selectedTheme)
            return TeamColor(rawValue: _selectedThemeRawValue) ?? .blueOrange
        }
        set {
            withMutation(keyPath: \.selectedTheme) {
                _selectedThemeRawValue = newValue.rawValue
                _team1Color = newValue.team1Color
                _team2Color = newValue.team2Color
            }
        }
    }
    
    func applyTheme(_ theme: TeamColor) {
        selectedTheme = theme
    }
}

enum DefaultsKey: String {
    case goldenPointEnabled = "goldenPoint"
    case tieBreakEnabled = "tieBreak"
    case team1Color = "team1Color"
    case team2Color = "team2Color"
    case selectedTheme = "selectedTheme"
}
