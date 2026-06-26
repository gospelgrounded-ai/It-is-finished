import Foundation

/// Each case is one step in the override gauntlet.
/// The flow is strictly linear; any "No" returns to .blocked.
///
/// blocked → confirm1 → prayer → cooldown1
///         → confirm2 → repentance → cooldown2
///         → confirm3 → callPartner → cooldown3 → unblocked
enum OverrideState: String, Codable {
    case blocked
    case confirm1
    case prayer
    case cooldown1
    case confirm2
    case repentance
    case cooldown2
    case confirm3
    case callPartner
    case cooldown3
    case unblocked
}
