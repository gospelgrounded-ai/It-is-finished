import Foundation

/// Records every meaningful moment in the user's journey.
/// Stored in StreakEvent.history for the future Journey view.
enum StreakEventType: String, Codable {
    case streakStarted
    case streakBroken
    case streakReinstated
    case battleWon        // Resisted the override at any confirm step
    case milestone7
    case milestone30
    case milestone90
    case milestone365
}
