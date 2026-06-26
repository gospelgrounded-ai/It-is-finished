import SwiftUI
import SwiftData

@main
struct ParakletosApp: App {

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [
            StreakState.self,
            StreakEvent.self,
            AccountabilityPartner.self,
            ScriptureEntry.self,
            PrayerTemplate.self,
            AppSettings.self
        ])
    }
}
