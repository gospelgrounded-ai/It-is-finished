import Foundation
import SwiftData

/// Single-row model — app-wide settings.
/// Insert one instance on first launch; fetch with `.first` everywhere.
@Model
final class AppSettings {
    var blockActive: Bool
    var screenTimePasscodeHeldBy: PasscodeHolder
    var notificationsEnabled: Bool
    var hasCompletedOnboarding: Bool

    init(
        blockActive: Bool = false,
        screenTimePasscodeHeldBy: PasscodeHolder = .me,
        notificationsEnabled: Bool = true,
        hasCompletedOnboarding: Bool = false
    ) {
        self.blockActive = blockActive
        self.screenTimePasscodeHeldBy = screenTimePasscodeHeldBy
        self.notificationsEnabled = notificationsEnabled
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
