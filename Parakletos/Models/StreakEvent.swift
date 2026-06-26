import Foundation
import SwiftData

@Model
final class StreakEvent {
    var type: StreakEventType
    var date: Date

    init(type: StreakEventType, date: Date = .now) {
        self.type = type
        self.date = date
    }
}
