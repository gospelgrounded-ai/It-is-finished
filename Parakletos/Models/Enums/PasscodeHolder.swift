import Foundation

/// Who physically holds the Screen Time passcode.
/// Shown during onboarding and in Settings.
enum PasscodeHolder: String, Codable, CaseIterable {
    case me
    case partner

    var displayName: String {
        switch self {
        case .me:      return "I hold it"
        case .partner: return "My accountability partner holds it"
        }
    }

    var explanation: String {
        switch self {
        case .me:
            // COPY: explain the "I hold it" choice
            return "You set the Screen Time passcode yourself. The app still walks you through the full override gauntlet — the friction is the point."
        case .partner:
            // COPY: explain the "partner holds it" choice
            return "Your partner sets and holds the passcode. If you ever want to lift the block permanently, you'll need to call them. The strongest wall is one you didn't build alone."
        }
    }
}
