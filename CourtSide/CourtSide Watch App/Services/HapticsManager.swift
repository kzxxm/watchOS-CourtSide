//
//  HapticsManager.swift
//  CourtSide
//
//  Created by Kassim Mirza on 23/01/2026.
//

import WatchKit

class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    static func gameWin() {
        WKInterfaceDevice.current().play(.click)
        print("(HapticManager) Game completion haptic triggered")
    }
    
    static func setWin() {
        WKInterfaceDevice.current().play(.success)
        print("(HapticManager) Set completion haptic triggered")

    }
}
