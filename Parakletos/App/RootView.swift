import SwiftUI
import SwiftData

/// Routes the app to Onboarding (first launch) or Home (returning user).
/// The switch is driven purely by AppSettings.hasCompletedOnboarding so
/// it reacts instantly when onboarding writes that flag to SwiftData.
struct RootView: View {

    @Query private var allSettings: [AppSettings]
    private var settings: AppSettings? { allSettings.first }

    var body: some View {
        if let settings, settings.hasCompletedOnboarding {
            HomeView()
        } else {
            OnboardingFlow()
        }
    }
}
