import SwiftUI

struct PrayerStepView: View {

    let prayerText: String
    let onComplete: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Image(systemName: "hands.sparkles")
                    .font(.system(size: 44, weight: .thin))
                    .foregroundStyle(Design.Colors.gold)

                // COPY: prayer screen heading — flag for review
                Text("Pray this now.")
                    .font(.system(size: 26, weight: .bold, design: .serif))
                    .foregroundStyle(Design.Colors.warmWhite)

                ScrollView {
                    Text(prayerText)
                        .font(Design.Typography.scripture)
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.85))
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                }
                .frame(maxHeight: 260)
            }

            Spacer()

            VStack(spacing: 12) {
                // COPY: prayer complete CTA — flag for review
                Button(action: onComplete) {
                    Text("I've prayed through this")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .primary))

                // COPY: prayer back button — flag for review
                Button(action: onBack) {
                    Text("Turn back — I don't need this")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Design.Colors.green)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }
}
