import SwiftUI
import SwiftData

struct HomeView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var streakStates: [StreakState]
    @Query private var scriptures: [ScriptureEntry]
    @Query private var allSettings: [AppSettings]
    @Query private var partners: [AccountabilityPartner]

    @StateObject private var overrideController = OverrideController()
    @State private var showOverrideFlow = false
    @State private var showEncouragement = false

    // MARK: - Derived state

    private var streak: StreakState? { streakStates.first }
    private var settings: AppSettings? { allSettings.first }
    private var partner: AccountabilityPartner? { partners.first }

    private var currentDays: Int {
        guard let streak else { return 0 }
        return StreakEngine.currentStreakDays(from: streak.currentStreakStart)
    }

    private var todayScripture: ScriptureEntry? {
        guard !scriptures.isEmpty else { return nil }
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 1
        let sorted = scriptures.sorted { $0.dayIndex < $1.dayIndex }
        return sorted[(dayOfYear - 1) % sorted.count]
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Design.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        StreakRingView(days: currentDays)
                            .padding(.top, 20)

                        if let scripture = todayScripture {
                            ScriptureCardView(entry: scripture)
                        }

                        statsRow

                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Parakletos")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(Design.Colors.gold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Design.Colors.warmWhite.opacity(0.6))
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showOverrideFlow, onDismiss: handleOverrideDismiss) {
            OverrideFlowView(controller: overrideController)
        }
        .overlay(alignment: .bottom) {
            if showEncouragement, let message = overrideController.encouragementMessage {
                EncouragementBanner(message: message) {
                    showEncouragement = false
                    overrideController.encouragementMessage = nil
                }
            }
        }
        .onAppear {
            if let streak { StreakEngine.checkAndUpdateLongest(state: streak) }
        }
        .task(id: streak?.currentStreakStart) {
            guard let streak, let settings else { return }
            NotificationManager.reschedule(
                enabled: settings.notificationsEnabled,
                streak: streak,
                scriptures: scriptures
            )
        }
    }

    // MARK: - Sub-views

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatBadgeView(
                icon: "shield.fill",
                value: "\(streak?.totalSaves ?? 0)",
                label: "battles won"
            )
            StatBadgeView(
                icon: "flame.fill",
                value: "\(streak?.longestStreakDays ?? 0)d",
                label: "personal best"
            )
            Spacer()
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 14) {
            if settings?.blockActive == true {
                // Block is on — offer the override gauntlet
                Button {
                    showOverrideFlow = true
                    overrideController.beginOverride()
                } label: {
                    Text("Override the block")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .warning))

            } else {
                // Block is off — offer reinstate
                Button {
                    if let streak {
                        overrideController.reinstateBlock(streakState: streak)
                    }
                    settings?.blockActive = true
                } label: {
                    Text("Reinstate the block")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .primary))
            }

            // One-tap call to partner
            if let partner, !partner.dialableNumber.isEmpty {
                Button {
                    openCall(to: partner)
                } label: {
                    Label("Call \(partner.name)", systemImage: "phone.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Design.Colors.gold)
                        .padding(.vertical, 8)
                }
            }
        }
    }

    // MARK: - Actions

    private func handleOverrideDismiss() {
        if overrideController.encouragementMessage != nil {
            showEncouragement = true
        }
        overrideController.reset()
    }

    private func openCall(to partner: AccountabilityPartner) {
        guard let url = URL(string: "tel:\(partner.dialableNumber)") else { return }
        UIApplication.shared.open(url)
    }
}
