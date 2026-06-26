import Foundation
import SwiftData

@Model
final class ScriptureEntry {
    var reference: String   // e.g. "1 Corinthians 10:13"
    var text: String
    var theme: Theme
    var dayIndex: Int       // 0-based; daily selection = dayOfYear % totalCount

    init(reference: String, text: String, theme: Theme, dayIndex: Int) {
        self.reference = reference
        self.text = text
        self.theme = theme
        self.dayIndex = dayIndex
    }
}
