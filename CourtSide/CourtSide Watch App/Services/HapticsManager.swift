//
//  HapticsManager.swift
//  CourtSide
//
//  Created by Kassim Mirza on 23/01/2026.
//

import WatchKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    static func gameWin() {
        WKInterfaceDevice.current().play(.click)
    }
    
    static func setWin() {
        WKInterfaceDevice.current().play(.success)
    }
}
