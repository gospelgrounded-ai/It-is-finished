import SwiftUI

/// Reused for confirm1, confirm2, and confirm3.
/// All copy is injected by OverrideFlowView so this view is purely structural.
struct ConfirmStepView: View {

    let stepNumber: Int
    let heading: String
    let message: String   // renamed from `body` — clashes with View.body
    let yesLabel: String
    let noLabel: String
    let onYes: () -> Void
    let onNo: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            stepIndicator
                .padding(.top, 20)

            ScrollView {

                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 44, weight: .thin))
                        .foregroundStyle(Design.Colors.warning.opacity(0.8))

                    Text(heading)
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundStyle(Design.Colors.warmWhite)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Text(message)
                        .font(.body)
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
                .padding(.bottom, 24)
            }

            VStack(spacing: 12) {
                // "No" is the hero button — placed first so the eye hits it first
                Button(action: onNo) {
                    Text(noLabel)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .primary))

                Button(action: onYes) {
                    Text(yesLabel)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .secondary))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var stepIndicator: some View {
        HStack(spacing: 6) {
            ForEach(1...3, id: \.self) { n in
                Capsule()
                    .fill(n <= stepNumber ? Design.Colors.gold : Design.Colors.surface)
                    .frame(width: n == stepNumber ? 24 : 8, height: 6)
            }
        }
    }
}
