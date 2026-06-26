import UserNotifications

/// Manages all local notifications: daily morning scripture and streak milestones.
/// Call reschedule() whenever the streak changes or settings toggle.
enum NotificationManager {

    private static let morningHour   = 7    // daily scripture fires at 7 AM
    private static let milestoneHour = 9    // milestone fires at 9 AM
    private static let windowDays    = 28   // schedule 4 weeks ahead (well under iOS 64-notification limit)
    private static let milestoneDays = [7, 30, 90, 365]

    // MARK: - Permission

    @discardableResult
    static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    // MARK: - Schedule

    /// Cancels all pending notifications then, if enabled, schedules daily
    /// scripture for the next 28 days and milestone notifications for any
    /// upcoming milestones the streak hasn't yet reached.
    static func reschedule(enabled: Bool, streak: StreakState, scriptures: [ScriptureEntry]) {
        cancelAll()
        guard enabled else { return }
        let today = Calendar.current.startOfDay(for: .now)
        let currentDays = StreakEngine.currentStreakDays(from: streak.currentStreakStart)
        scheduleDailyScriptures(from: today, currentDays: currentDays, scriptures: scriptures)
        scheduleMilestones(streakStart: streak.currentStreakStart, currentDays: currentDays)
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Daily scripture (28 days)

    private static func scheduleDailyScriptures(
        from today: Date,
        currentDays: Int,
        scriptures: [ScriptureEntry]
    ) {
        guard !scriptures.isEmpty else { return }
        let center = UNUserNotificationCenter.current()
        let sorted = scriptures.sorted { $0.dayIndex < $1.dayIndex }
        let count  = sorted.count

        for offset in 0..<windowDays {
            let scripture = sorted[(currentDays + offset) % count]

            guard let fireDate = Calendar.current
                .date(byAdding: .day, value: offset, to: today)
                .flatMap({ Calendar.current.date(bySettingHour: morningHour, minute: 0, second: 0, of: $0) }),
                  fireDate > .now else { continue }

            let content = UNMutableNotificationContent()
            // COPY: daily notification title — flag for review
            content.title = scripture.reference
            // COPY: daily notification body — flag for review
            content.body  = scripture.text
            content.sound = .default

            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour], from: fireDate)
            center.add(UNNotificationRequest(
                identifier: "daily-\(offset)",
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            ))
        }
    }

    // MARK: - Milestones

    private static func scheduleMilestones(streakStart: Date, currentDays: Int) {
        let center = UNUserNotificationCenter.current()
        let cal    = Calendar.current

        for days in milestoneDays where days > currentDays {
            guard let fireDate = cal
                .date(byAdding: .day, value: days, to: cal.startOfDay(for: streakStart))
                .flatMap({ cal.date(bySettingHour: milestoneHour, minute: 0, second: 0, of: $0) }),
                  fireDate > .now else { continue }

            let content = UNMutableNotificationContent()
            // COPY: milestone notification title — flag for review
            content.title = milestoneTitle(days)
            // COPY: milestone notification body — flag for review
            content.body  = milestoneBody(days)
            content.sound = .default

            let comps = cal.dateComponents([.year, .month, .day, .hour], from: fireDate)
            center.add(UNNotificationRequest(
                identifier: "milestone-\(days)",
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            ))
        }
    }

    // COPY: milestone titles — flag for review
    private static func milestoneTitle(_ days: Int) -> String {
        switch days {
        case 7:   return "7 days standing firm."
        case 30:  return "30 days. A month of freedom."
        case 90:  return "90 days. Real change."
        case 365: return "One year. This is who you are now."
        default:  return "\(days) days free."
        }
    }

    // COPY: milestone bodies — flag for review
    private static func milestoneBody(_ days: Int) -> String {
        switch days {
        case 7:   return "Seven days of choosing differently. Keep going."
        case 30:  return "A month. The battle is real — so is the victory."
        case 90:  return "Ninety days. Your brain is rewiring. God is faithful."
        case 365: return "\"He who began a good work in you will carry it on.\" — Phil 1:6"
        default:  return "You are not who you were."
        }
    }
}
