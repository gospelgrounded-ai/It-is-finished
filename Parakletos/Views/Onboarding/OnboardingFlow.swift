import SwiftUI
import SwiftData

/// Root container for onboarding.  Shown as a fullScreenCover on first launch.
/// Uses a NavigationStack so each step slides in naturally.
struct OnboardingFlow: View {

    @Environment(\.modelContext) private var modelContext

    // Local state collected across steps before committing to SwiftData
    @State private var partnerName = ""
    @State private var partnerPhone = ""
    @State private var passcodeHolder: PasscodeHolder = .partner

    var body: some View {
        NavigationStack {
            WelcomeView(
                partnerName: $partnerName,
                partnerPhone: $partnerPhone,
                passcodeHolder: $passcodeHolder,
                onActivate: activate
            )
        }
        .preferredColorScheme(.dark)
    }

    /// Called by ActivateView when the user taps "Activate Parakletos".
    /// Writes all first-launch data to SwiftData in a single pass.
    private func activate() {
        // Partner
        let partner = AccountabilityPartner(name: partnerName, phoneNumber: partnerPhone)
        modelContext.insert(partner)

        // Streak state
        let streak = StreakState(currentStreakStart: .now)
        streak.history.append(StreakEvent(type: .streakStarted))
        modelContext.insert(streak)

        // Settings — marks onboarding complete, which hides this flow
        let settings = AppSettings(
            blockActive: true,
            screenTimePasscodeHeldBy: passcodeHolder,
            notificationsEnabled: true,
            hasCompletedOnboarding: true
        )
        modelContext.insert(settings)

        // Seed scripture + prayer content
        SeedLoader.loadIfNeeded(in: modelContext)

        Task { await NotificationManager.requestAuthorization() }
    }
}
