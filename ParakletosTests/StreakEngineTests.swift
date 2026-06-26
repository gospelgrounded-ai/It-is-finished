import XCTest
import SwiftData
@testable import Parakletos

final class StreakEngineTests: XCTestCase {

    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUp() {
        super.setUp()
        container = try! ModelContainer(
            for: StreakState.self, StreakEvent.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = container.mainContext
    }

    override func tearDown() {
        container = nil
        context = nil
        super.tearDown()
    }

    // MARK: - currentStreakDays

    func testStreakIsZeroOnSameDay() {
        let days = StreakEngine.currentStreakDays(from: .now, to: .now)
        XCTAssertEqual(days, 0)
    }

    func testStreakIsOneAfterOneDay() {
        let start = Date.now.addingTimeInterval(-86_400)
        let days = StreakEngine.currentStreakDays(from: start, to: .now)
        XCTAssertEqual(days, 1)
    }

    func testStreakIsFortyAfterFortyDays() {
        let start = Date.now.addingTimeInterval(-86_400 * 40)
        let days = StreakEngine.currentStreakDays(from: start, to: .now)
        XCTAssertEqual(days, 40)
    }

    func testStreakIsNeverNegative() {
        // Future start date (shouldn't happen, but be defensive)
        let futureStart = Date.now.addingTimeInterval(86_400)
        let days = StreakEngine.currentStreakDays(from: futureStart, to: .now)
        XCTAssertEqual(days, 0)
    }

    func testStreakCrossesMidnight() {
        // Start yesterday at 23:59:59 — today should be day 1
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        let yesterday = cal.startOfDay(for: .now).addingTimeInterval(-1)  // 23:59:59 yesterday
        let days = StreakEngine.currentStreakDays(from: yesterday, to: .now)
        XCTAssertEqual(days, 1)
    }

    // MARK: - breakStreak

    func testBreakStreakResetsCurrentStreakToZero() {
        let state = makeState(daysAgo: 7)
        StreakEngine.breakStreak(state: state)
        let days = StreakEngine.currentStreakDays(from: state.currentStreakStart)
        XCTAssertEqual(days, 0)
    }

    func testBreakStreakRecordsEvent() {
        let state = makeState(daysAgo: 3)
        StreakEngine.breakStreak(state: state)
        XCTAssertEqual(state.history.count, 1)
        XCTAssertEqual(state.history.first?.type, .streakBroken)
    }

    func testBreakStreakDoesNotReduceLongest() {
        let state = makeState(daysAgo: 3)
        state.longestStreakDays = 30
        StreakEngine.breakStreak(state: state)
        XCTAssertEqual(state.longestStreakDays, 30)
    }

    // MARK: - reinstate

    func testReinstateResetsCurrentStreakToZero() {
        let state = makeState(daysAgo: 5)
        StreakEngine.reinstate(state: state)
        let days = StreakEngine.currentStreakDays(from: state.currentStreakStart)
        XCTAssertEqual(days, 0)
    }

    func testReinstateRecordsEvent() {
        let state = makeState(daysAgo: 0)
        StreakEngine.reinstate(state: state)
        XCTAssertEqual(state.history.last?.type, .streakReinstated)
    }

    // MARK: - logSave

    func testLogSaveIncrementsTotalSaves() {
        let state = makeState(daysAgo: 0)
        StreakEngine.logSave(state: state)
        StreakEngine.logSave(state: state)
        StreakEngine.logSave(state: state)
        XCTAssertEqual(state.totalSaves, 3)
    }

    func testLogSaveRecordsBattleWonEvent() {
        let state = makeState(daysAgo: 0)
        StreakEngine.logSave(state: state)
        XCTAssertEqual(state.history.last?.type, .battleWon)
    }

    // MARK: - checkAndUpdateLongest

    func testLongestDoesNotDecreaseWhenCurrentIsShorter() {
        let state = makeState(daysAgo: 5)
        state.longestStreakDays = 10
        StreakEngine.checkAndUpdateLongest(state: state)
        XCTAssertEqual(state.longestStreakDays, 10)
    }

    func testLongestUpdatesWhenCurrentExceeds() {
        let state = makeState(daysAgo: 15)
        state.longestStreakDays = 10
        StreakEngine.checkAndUpdateLongest(state: state)
        XCTAssertEqual(state.longestStreakDays, 15)
    }

    func testLongestStartsAtZeroAndUpdates() {
        let state = makeState(daysAgo: 7)
        StreakEngine.checkAndUpdateLongest(state: state)
        XCTAssertEqual(state.longestStreakDays, 7)
    }

    // MARK: - milestoneReached

    func testKnownMilestonesDetected() {
        XCTAssertEqual(StreakEngine.milestoneReached(for: 7),   .milestone7)
        XCTAssertEqual(StreakEngine.milestoneReached(for: 30),  .milestone30)
        XCTAssertEqual(StreakEngine.milestoneReached(for: 90),  .milestone90)
        XCTAssertEqual(StreakEngine.milestoneReached(for: 365), .milestone365)
    }

    func testNonMilestoneDaysReturnNil() {
        XCTAssertNil(StreakEngine.milestoneReached(for: 0))
        XCTAssertNil(StreakEngine.milestoneReached(for: 1))
        XCTAssertNil(StreakEngine.milestoneReached(for: 15))
        XCTAssertNil(StreakEngine.milestoneReached(for: 100))
    }

    // MARK: - Helpers

    private func makeState(daysAgo: Int) -> StreakState {
        let start = Date.now.addingTimeInterval(-86_400 * Double(daysAgo))
        let state = StreakState(currentStreakStart: start)
        context.insert(state)
        return state
    }
}
