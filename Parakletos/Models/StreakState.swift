import Foundation
import SwiftData

/// Single-row model — only one instance exists in the store.
/// Fetch with `.first` everywhere; insert one on first launch.
@Model
final class StreakState {
    var currentStreakStart: Date
    var longestStreakDays: Int
    var totalSaves: Int           // Battles won: times user turned back

    @Relationship(deleteRule: .cascade)
    var history: [StreakEvent]

    init(
        currentStreakStart: Date = .now,
        longestStreakDays: Int = 0,
        totalSaves: Int = 0
    ) {
        self.currentStreakStart = currentStreakStart
        self.longestStreakDays = longestStreakDays
        self.totalSaves = totalSaves
        self.history = []
    }
}
