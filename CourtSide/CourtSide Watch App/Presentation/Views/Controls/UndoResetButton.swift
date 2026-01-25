//
//  UndoResetButton.swift
//  CourtSide Watch App
//
//  Created by Kassim Mirza on 25/01/2026.
//

import SwiftUI

struct UndoResetButton: View {
    let onUndo: () -> Void
    let onReset: () -> Void
    let canUndo: Bool
    
    @State private var showResetConfirmation = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Button {
            onUndo()
            HapticsManager.undo()
        } label: {
            ZStack {
                Circle()
                    .fill(.red.opacity(0.25))
                    .frame(height: 44)
                
                HStack(spacing: 8) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.caption)
                }
                .foregroundStyle(.red)
            }
        }
        .padding()
        .buttonStyle(.plain)
        .disabled(!canUndo)
        .opacity(canUndo ? 1.0 : 0.5)
        .scaleEffect(scale)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.8)
                .onChanged { _ in
                    // Visual feedback during long press
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scale = 0.95
                    }
                }
                .onEnded { _ in
                    // Long press completed - show reset confirmation
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scale = 1.0
                    }
                    WKInterfaceDevice.current().play(.success)
                    showResetConfirmation = true
                }
        )
        .onChange(of: showResetConfirmation) { oldValue, newValue in
            // Reset scale if dialog is dismissed
            if !newValue {
                withAnimation(.easeInOut(duration: 0.2)) {
                    scale = 1.0
                }
            }
        }
        .confirmationDialog(
            "Reset Match",
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset Match", role: .destructive) {
                onReset()
                HapticsManager.reset()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to reset the match? This will clear all scores and history.")
        }
    }
}

#Preview("Can Undo") {
    UndoResetButton(
        onUndo: { print("Undo tapped") },
        onReset: { print("Reset confirmed") },
        canUndo: true
    )
    .padding()
}

#Preview("Cannot Undo") {
    UndoResetButton(
        onUndo: { print("Undo tapped") },
        onReset: { print("Reset confirmed") },
        canUndo: false
    )
    .padding()
}
