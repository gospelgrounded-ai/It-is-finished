import Foundation

/// Pure functions — no SwiftData imports, no UIKit, fully unit-testable.
/// All mutations take the SwiftData model as an inout-style parameter so
/// callers can save the context after calling.
enum StreakEngine {

    // MARK: - Read

    /// Number of whole calendar days between `start` and `now`.
    /// Returns 0 on the day the streak begins; 1 the next day, etc.
    static func currentStreakDays(from start: Date, to now: Date = .now) -> Int {
        let cal = Calendar.current
        let fromDay = cal.startOfDay(for: start)
        let toDay = cal.startOfDay(for: now)
        let diff = cal.dateComponents([.day], from: fromDay, to: toDay)
        return max(0, diff.day ?? 0)
    }

    // MARK: - Mutations

    /// Record a "battle won" — user turned back at a confirm step.
    static func logSave(state: StreakState) {
        state.totalSaves += 1
        state.history.append(StreakEvent(type: .battleWon))
    }

    /// Override completed — reset streak to today.
    static func breakStreak(state: StreakState) {
        state.history.append(StreakEvent(type: .streakBroken))
        state.currentStreakStart = .now
    }

    /// User reinstates the block after an unblocked session — fresh start.
    static func reinstate(state: StreakState) {
        state.currentStreakStart = .now
        state.history.append(StreakEvent(type: .streakReinstated))
        checkAndUpdateLongest(state: state)
    }

    /// Call this on app foreground and after reinstate to keep longestStreakDays current.
    static func checkAndUpdateLongest(state: StreakState, now: Date = .now) {
        let current = currentStreakDays(from: state.currentStreakStart, to: now)
        if current > state.longestStreakDays {
            state.longestStreakDays = current
        }
    }

    // MARK: - Milestones

    /// Returns a milestone event type if `days` is a milestone day, otherwise nil.
    static func milestoneReached(for days: Int) -> StreakEventType? {
        switch days {
        case 7:   return .milestone7
        case 30:  return .milestone30
        case 90:  return .milestone90
        case 365: return .milestone365
        default:  return nil
        }
    }
}
