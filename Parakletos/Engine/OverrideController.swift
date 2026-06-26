import Foundation
import Combine

/// Drives the 9-step override gauntlet.
///
/// Flow:
///   blocked → confirm1 → prayer → cooldown1
///           → confirm2 → repentance → cooldown2
///           → confirm3 → callPartner → cooldown3 → unblocked
///
/// Any "No" at a confirm step → blocked + logSave() + encouragementMessage set.
/// Cooldown steps: `secondsRemaining` counts down; the UI disables its
/// "Continue" button until it reaches zero, then the user taps to proceed.
@MainActor
final class OverrideController: ObservableObject {

    @Published var state: OverrideState = .blocked
    @Published var secondsRemaining: Int = 0
    @Published var encouragementMessage: String? = nil

    private var timerCancellable: AnyCancellable?
    private var cooldownStart: Date?
    private let cooldownDuration: TimeInterval = 60

    // COPY: Grace messages shown when user says "No" at any confirm step.
    // Flag for theological review — tone should be warm and specific, not generic.
    private let resistanceMessages: [String] = [
        "Well done. That took real strength.",
        "You chose freedom. That matters more than you know.",
        "One battle at a time. You just won this one.",
        "Your future self is grateful for what you did just now.",
        "Standing firm is never wasted. Heaven noticed.",
        "This is what courage looks like. Keep going."
    ]

    // MARK: - Entry points

    /// Called when user taps "Override the block" on the home screen.
    func beginOverride() {
        guard state == .blocked else { return }
        transition(to: .confirm1)
    }

    /// Called when user taps "Yes / I'm sure" at any confirm step.
    func confirmYes() {
        switch state {
        case .confirm1: transition(to: .prayer)
        case .confirm2: transition(to: .repentance)
        case .confirm3: transition(to: .callPartner)
        default: break
        }
    }

    /// Called when user taps "No / Turn back" at any confirm step.
    func confirmNo(streakState: StreakState) {
        StreakEngine.logSave(state: streakState)
        encouragementMessage = resistanceMessages.randomElement()
        transition(to: .blocked)
    }

    /// Called when user taps "I've prayed through this" on the prayer screen.
    func completePrayer() {
        guard state == .prayer else { return }
        startCooldown(cooldownState: .cooldown1, nextState: .confirm2)
    }

    /// Called when user taps "Continue" on the repentance screen.
    func completeRepentance() {
        guard state == .repentance else { return }
        startCooldown(cooldownState: .cooldown2, nextState: .confirm3)
    }

    /// Called when user taps either "Call now" or "Continue without calling"
    /// on the call-partner screen.
    func proceedFromCallPartner() {
        guard state == .callPartner else { return }
        startCooldown(cooldownState: .cooldown3, nextState: .unblocked)
    }

    /// Called once the cooldown timer reaches zero AND the user taps "Continue".
    /// The button in CooldownStepView is disabled while secondsRemaining > 0.
    func advanceFromCooldown() {
        guard secondsRemaining == 0 else { return }
        switch state {
        case .cooldown1: transition(to: .confirm2)
        case .cooldown2: transition(to: .confirm3)
        case .cooldown3: transition(to: .unblocked)
        default: break
        }
    }

    /// Called once the unblocked screen appears — records the streak break.
    func finalizeUnblock(streakState: StreakState) {
        guard state == .unblocked else { return }
        StreakEngine.breakStreak(state: streakState)
    }

    /// Available anytime after unblocked — fresh start.
    func reinstateBlock(streakState: StreakState) {
        StreakEngine.reinstate(state: streakState)
        transition(to: .blocked)
    }

    /// Reset to initial state — called when the override flow sheet is dismissed.
    func reset() {
        timerCancellable?.cancel()
        timerCancellable = nil
        cooldownStart = nil
        state = .blocked
        secondsRemaining = 0
        encouragementMessage = nil
    }

    // MARK: - Cooldown internals

    private func startCooldown(cooldownState: OverrideState, nextState: OverrideState) {
        cooldownStart = .now
        secondsRemaining = Int(cooldownDuration)
        transition(to: cooldownState)

        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, let start = self.cooldownStart else { return }
                let elapsed = Date.now.timeIntervalSince(start)
                let remaining = max(0, Int(ceil(self.cooldownDuration - elapsed)))
                self.secondsRemaining = remaining
                if remaining == 0 {
                    self.timerCancellable?.cancel()
                    // Timer is done; the Continue button is now enabled.
                    // The user must still tap it — we don't auto-advance.
                }
            }
    }

    private func transition(to newState: OverrideState) {
        state = newState
    }
}
