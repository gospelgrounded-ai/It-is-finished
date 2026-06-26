import SwiftUI
import SwiftData

/// Full-screen container that routes to the correct step view
/// based on OverrideController.state.
struct OverrideFlowView: View {

    @ObservedObject var controller: OverrideController
    @Environment(\.dismiss) private var dismiss
    @Query private var streakStates: [StreakState]
    @Query private var prayers: [PrayerTemplate]

    private var streak: StreakState? { streakStates.first }

    // Pick a prayer from the seed — randomise for variety, fall back to a hardcoded one
    private var currentPrayer: String {
        prayers.randomElement()?.body ?? PrayerFallback.text
    }

    var body: some View {
        ZStack {
            Design.Colors.background.ignoresSafeArea()
            stepView
        }
        .preferredColorScheme(.dark)
        .onChange(of: controller.state) { _, newState in
            if newState == .blocked { dismiss() }
        }
        .onChange(of: controller.state) { _, newState in
            if newState == .unblocked {
                if let streak { controller.finalizeUnblock(streakState: streak) }
            }
        }
    }

    @ViewBuilder
    private var stepView: some View {
        switch controller.state {
        case .blocked:
            // Transitioning away — show nothing to avoid flash
            Color.clear

        case .confirm1:
            ConfirmStepView(
                stepNumber: 1,
                // COPY: confirm1 heading — flag for review
                heading: "Are you sure you want to do this?",
                // COPY: confirm1 body — flag for review
                message: "There is a way out of this moment. You don't have to keep going.",
                // COPY: confirm1 yes label — flag for review
                yesLabel: "Yes, continue",
                // COPY: confirm1 no label — flag for review
                noLabel: "Turn back",
                onYes: { controller.confirmYes() },
                onNo: { if let s = streak { controller.confirmNo(streakState: s) } }
            )

        case .prayer:
            PrayerStepView(
                prayerText: currentPrayer,
                onComplete: { controller.completePrayer() },
                onBack: { if let s = streak { controller.confirmNo(streakState: s) } }
            )

        case .cooldown1:
            CooldownStepView(
                stepNumber: 1,
                // COPY: cooldown1 message — flag for review
                message: "Pause. Take a breath. This moment will pass.",
                secondsRemaining: controller.secondsRemaining,
                onContinue: { controller.advanceFromCooldown() }
            )

        case .confirm2:
            ConfirmStepView(
                stepNumber: 2,
                // COPY: confirm2 heading — flag for review
                heading: "You've prayed. Are you still choosing this?",
                // COPY: confirm2 body — flag for review
                message: "You can still turn back. Every time you do, it counts.",
                yesLabel: "Yes, continue",
                noLabel: "I'm turning back",
                onYes: { controller.confirmYes() },
                onNo: { if let s = streak { controller.confirmNo(streakState: s) } }
            )

        case .repentance:
            RepentanceStepView(
                onComplete: { controller.completeRepentance() },
                onBack: { if let s = streak { controller.confirmNo(streakState: s) } }
            )

        case .cooldown2:
            CooldownStepView(
                stepNumber: 2,
                // COPY: cooldown2 message — flag for review
                message: "Your brother is fighting this too. You're not alone in this.",
                secondsRemaining: controller.secondsRemaining,
                onContinue: { controller.advanceFromCooldown() }
            )

        case .confirm3:
            ConfirmStepView(
                stepNumber: 3,
                // COPY: confirm3 heading — flag for review
                heading: "Last chance to turn back.",
                // COPY: confirm3 body — flag for review
                message: "You have prayed. You have reflected. There is still grace for you right now.",
                yesLabel: "I still want to continue",
                noLabel: "I'm choosing freedom",
                onYes: { controller.confirmYes() },
                onNo: { if let s = streak { controller.confirmNo(streakState: s) } }
            )

        case .callPartner:
            CallPartnerStepView(
                onProceed: { controller.proceedFromCallPartner() }
            )

        case .cooldown3:
            CooldownStepView(
                stepNumber: 3,
                // COPY: cooldown3 message — flag for review
                message: "One last minute. Use it to reconsider. There is no shame in stopping here.",
                secondsRemaining: controller.secondsRemaining,
                onContinue: { controller.advanceFromCooldown() }
            )

        case .unblocked:
            UnblockedView(onDismiss: { dismiss() })
        }
    }
}

// MARK: - Fallback prayer if DB is empty

private enum PrayerFallback {
    // COPY: fallback prayer shown if seed hasn't loaded — flag for review
    static let text = "Father, I come to you honestly right now. You know the pull I feel. Give me the strength to choose differently. I don't want momentary relief more than I want you. Amen."
}
