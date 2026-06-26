import Foundation
import SwiftData

@Model
final class PrayerTemplate {
    var theme: Theme
    var body: String    // The full prayer text shown to the user

    init(theme: Theme, body: String) {
        self.theme = theme
        self.body = body
    }
}
