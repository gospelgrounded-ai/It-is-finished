import SwiftUI
import SwiftData

struct SettingsView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var allSettings: [AppSettings]
    @Query private var partners: [AccountabilityPartner]
    @Query private var streakStates: [StreakState]

    @StateObject private var overrideController = OverrideController()

    @State private var editingPartnerName = ""
    @State private var editingPartnerPhone = ""
    @State private var isEditingPartner = false

    private var settings: AppSettings? { allSettings.first }
    private var partner: AccountabilityPartner? { partners.first }
    private var streak: StreakState? { streakStates.first }

    var body: some View {
        ZStack {
            Design.Colors.background.ignoresSafeArea()

            List {
                // ── Block status ────────────────────────────────────────
                Section {
                    HStack {
                        Label(
                            settings?.blockActive == true ? "Block is ON" : "Block is OFF",
                            systemImage: settings?.blockActive == true ? "lock.fill" : "lock.open"
                        )
                        .foregroundStyle(
                            settings?.blockActive == true ? Design.Colors.green : Design.Colors.warning
                        )

                        Spacer()

                        if settings?.blockActive == false {
                            Button("Reinstate") {
                                if let streak {
                                    overrideController.reinstateBlock(streakState: streak)
                                }
                                settings?.blockActive = true
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Design.Colors.gold)
                        }
                    }
                } header: {
                    Text("Block")
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.4))
                }
                .listRowBackground(Design.Colors.surface)

                // ── Passcode holder ─────────────────────────────────────
                Section {
                    Picker("Passcode held by", selection: Binding(
                        get: { settings?.screenTimePasscodeHeldBy ?? .me },
                        set: { settings?.screenTimePasscodeHeldBy = $0 }
                    )) {
                        ForEach(PasscodeHolder.allCases, id: \.self) { choice in
                            Text(choice == .me ? "Me" : "My partner")
                                .tag(choice)
                        }
                    }
                    .foregroundStyle(Design.Colors.warmWhite)
                } header: {
                    Text("Screen Time")
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.4))
                }
                .listRowBackground(Design.Colors.surface)

                // ── Partner ─────────────────────────────────────────────
                Section {
                    if isEditingPartner {
                        TextField("Name", text: $editingPartnerName)
                            .foregroundStyle(Design.Colors.warmWhite)
                        TextField("Phone number", text: $editingPartnerPhone)
                            .keyboardType(.phonePad)
                            .foregroundStyle(Design.Colors.warmWhite)

                        HStack {
                            Button("Save") { savePartner() }
                                .foregroundStyle(Design.Colors.gold)
                            Spacer()
                            Button("Cancel") { isEditingPartner = false }
                                .foregroundStyle(Design.Colors.warmWhite.opacity(0.4))
                        }
                    } else {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(partner?.name.isEmpty == false ? partner!.name : "No partner set")
                                    .foregroundStyle(Design.Colors.warmWhite)
                                Text(partner?.phoneNumber.isEmpty == false ? partner!.phoneNumber : "—")
                                    .font(.footnote)
                                    .foregroundStyle(Design.Colors.warmWhite.opacity(0.45))
                            }
                            Spacer()
                            Button("Edit") {
                                editingPartnerName = partner?.name ?? ""
                                editingPartnerPhone = partner?.phoneNumber ?? ""
                                isEditingPartner = true
                            }
                            .font(.subheadline)
                            .foregroundStyle(Design.Colors.gold)
                        }

                        if let partner, !partner.dialableNumber.isEmpty {
                            Button {
                                if let url = URL(string: "tel:\(partner.dialableNumber)") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Label("Call \(partner.name)", systemImage: "phone.fill")
                                    .foregroundStyle(Design.Colors.gold)
                            }
                        }
                    }
                } header: {
                    Text("Accountability Partner")
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.4))
                }
                .listRowBackground(Design.Colors.surface)

                // ── Notifications (stub) ─────────────────────────────────
                Section {
                    Toggle(isOn: Binding(
                        get: { settings?.notificationsEnabled ?? true },
                        set: { settings?.notificationsEnabled = $0 }
                    )) {
                        Text("Daily encouragement")
                            .foregroundStyle(Design.Colors.warmWhite)
                    }
                    .tint(Design.Colors.gold)
                } header: {
                    Text("Notifications")
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.4))
                } footer: {
                    // COPY: notifications footer — flag for review
                    Text("A short scripture or reminder each morning. Full notification setup coming in M3.")
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.3))
                }
                .listRowBackground(Design.Colors.surface)

                // ── About ────────────────────────────────────────────────
                Section {
                    HStack {
                        Text("Version")
                            .foregroundStyle(Design.Colors.warmWhite)
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundStyle(Design.Colors.warmWhite.opacity(0.4))
                    }
                    HStack {
                        Text("Privacy")
                            .foregroundStyle(Design.Colors.warmWhite)
                        Spacer()
                        Text("Everything stays on this device")
                            .font(.footnote)
                            .foregroundStyle(Design.Colors.warmWhite.opacity(0.4))
                    }
                } header: {
                    Text("About")
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.4))
                }
                .listRowBackground(Design.Colors.surface)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    private func savePartner() {
        if let existing = partner {
            existing.name = editingPartnerName
            existing.phoneNumber = editingPartnerPhone
        } else {
            modelContext.insert(AccountabilityPartner(
                name: editingPartnerName,
                phoneNumber: editingPartnerPhone
            ))
        }
        isEditingPartner = false
    }
}
