import SwiftUI

struct ActivateView: View {

    let passcodeHolder: PasscodeHolder
    let partnerName: String
    let onActivate: () -> Void

    var body: some View {
        ZStack {
            Design.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                // Summary card
                VStack(spacing: 20) {
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.system(size: 52, weight: .thin))
                        .foregroundStyle(Design.Colors.gold)

                    // COPY: Activation heading — flag for review
                    Text("You're ready.")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(Design.Colors.warmWhite)

                    VStack(spacing: 10) {
                        SummaryRow(
                            icon: "person.fill",
                            text: partnerName.isEmpty
                                ? "Accountability partner added"
                                : "\(partnerName) is in your corner"
                        )
                        SummaryRow(
                            icon: "lock.fill",
                            text: passcodeHolder == .partner
                                ? "\(partnerName.isEmpty ? "Your partner" : partnerName) holds the passcode"
                                : "You hold the passcode"
                        )
                        SummaryRow(icon: "iphone", text: "Everything stays on this device")
                    }
                    .padding(.horizontal, 16)
                }
                .padding(28)
                .background(Design.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .padding(.top, 52)
                .padding(.bottom, 24)
                } // ScrollView

                VStack(spacing: 12) {
                    // COPY: Note below activate button — flag for review
                    Text("Activating starts your streak from today and turns on the block. You can change settings any time.")
                        .font(.footnote)
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.45))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button {
                        onActivate()
                    } label: {
                        Text("Activate Parakletos")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 48)
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(false)
    }
}

// MARK: - Summary row

private struct SummaryRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.footnote)
                .foregroundStyle(Design.Colors.gold)
                .frame(width: 20)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(Design.Colors.warmWhite.opacity(0.8))

            Spacer()
        }
    }
}
