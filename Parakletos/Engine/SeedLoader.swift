import Foundation
import SwiftData

/// Loads parakletos-content-seed.json into the SwiftData store on first launch.
/// Safe to call on every launch — it checks whether content already exists
/// before doing anything.
enum SeedLoader {

    static func loadIfNeeded(in context: ModelContext) {
        do {
            let existingCount = try context.fetchCount(FetchDescriptor<ScriptureEntry>())
            guard existingCount == 0 else { return }
            try seed(into: context)
        } catch {
            // Non-fatal: app works without seeded content; scripture card is simply hidden.
        }
    }

    private static func seed(into context: ModelContext) throws {
        guard
            let url = Bundle.main.url(forResource: "parakletos-content-seed", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else { return }

        let raw = try JSONDecoder().decode(RawSeed.self, from: data)

        for entry in raw.scriptures {
            context.insert(ScriptureEntry(
                reference: entry.reference,
                text: entry.text,
                theme: entry.theme,
                dayIndex: entry.dayIndex
            ))
        }

        for prayer in raw.prayers {
            context.insert(PrayerTemplate(theme: prayer.theme, body: prayer.body))
        }
    }

    // MARK: - Decodable intermediates

    private struct RawSeed: Decodable {
        let scriptures: [RawScripture]
        let prayers: [RawPrayer]
    }

    private struct RawScripture: Decodable {
        let reference: String
        let text: String
        let theme: Theme
        let dayIndex: Int
    }

    private struct RawPrayer: Decodable {
        let theme: Theme
        let body: String
    }
}
