import SwiftUI
import SwiftData

struct CallPartnerStepView: View {

    let onProceed: () -> Void

    @Query private var partners: [AccountabilityPartner]
    private var partner: AccountabilityPartner? { partners.first }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "phone.circle")
                    .font(.system(size: 60, weight: .thin))
                    .foregroundStyle(Design.Colors.gold)

                // COPY: call partner heading — flag for review
                Text("Call \(partner?.name ?? "your partner").")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(Design.Colors.warmWhite)
                    .multilineTextAlignment(.center)

                // COPY: call partner body — flag for review
                Text("He signed up for moments exactly like this one. You won't be a burden — you'll be giving him the chance to be the man he wants to be too.")
                    .font(.body)
                    .foregroundStyle(Design.Colors.warmWhite.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 52)
            .padding(.bottom, 24)
            } // ScrollView

            VStack(spacing: 12) {
                if let partner, !partner.dialableNumber.isEmpty {
                    Button {
                        openCall(to: partner)
                        onProceed()
                    } label: {
                        Label("Call \(partner.name) now", systemImage: "phone.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle(style: .primary))
                }

                // Always available — we can't force a call
                Button(action: onProceed) {
                    // COPY: skip call label — flag for review
                    Text("Continue without calling")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .secondary))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }

    private func openCall(to partner: AccountabilityPartner) {
        guard let url = URL(string: "tel:\(partner.dialableNumber)") else { return }
        UIApplication.shared.open(url)
    }
}
