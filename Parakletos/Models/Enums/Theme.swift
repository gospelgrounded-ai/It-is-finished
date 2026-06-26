import Foundation

/// The eight spiritual themes that organise scripture and prayer content.
enum Theme: String, Codable, CaseIterable {
    case escape
    case guardHeart  // `guard` is a Swift keyword; stored as "guardHeart"
    case identity
    case spirit
    case body
    case temptation
    case repentance
    case grace

    var displayName: String {
        switch self {
        case .escape:      return "Escape"
        case .guardHeart:  return "Guard Your Heart"
        case .identity:    return "Identity"
        case .spirit:      return "Walk in the Spirit"
        case .body:        return "Your Body"
        case .temptation:  return "Temptation"
        case .repentance:  return "Repentance"
        case .grace:       return "Grace"
        }
    }
}
