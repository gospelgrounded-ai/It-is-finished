import SwiftUI

struct WelcomeView: View {

    @Binding var partnerName: String
    @Binding var partnerPhone: String
    @Binding var passcodeHolder: PasscodeHolder
    let onActivate: () -> Void

    var body: some View {
        ZStack {
            Design.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 32) {
                        // App name + cross motif
                        VStack(spacing: 16) {
                            Image(systemName: "shield.lefthalf.filled")
                                .font(.system(size: 64, weight: .thin))
                                .foregroundStyle(Design.Colors.gold)

                            Text("Parakletos")
                                .font(.system(size: 38, weight: .bold, design: .serif))
                                .foregroundStyle(Design.Colors.warmWhite)

                            // COPY: Tagline — flag for theological review
                            Text("Freedom is a fight worth taking seriously.")
                                .font(.subheadline)
                                .foregroundStyle(Design.Colors.warmWhite.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }

                        // COPY: Body — flag for theological review
                        VStack(spacing: 12) {
                            Text("This app creates friction between you and pornography — not to shame you, but to give you time to choose differently.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Design.Colors.warmWhite.opacity(0.75))
                                .font(.body)

                            Text("Everything stays on your device. No account. No tracking. No one but you and God.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Design.Colors.warmWhite.opacity(0.5))
                                .font(.footnote)
                        }
                        .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                    .padding(.bottom, 24)
                }

                NavigationLink {
                    PartnerSetupView(
                        partnerName: $partnerName,
                        partnerPhone: $partnerPhone,
                        passcodeHolder: $passcodeHolder,
                        onActivate: onActivate
                    )
                } label: {
                    Text("Let's begin")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
    }
}
