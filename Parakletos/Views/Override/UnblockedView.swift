import SwiftUI

/// Shown after all 9 steps are completed.
/// OverrideFlowView has already called finalizeUnblock() (breakStreak) by this point.
struct UnblockedView: View {

    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "lock.open")
                        .font(.system(size: 52, weight: .thin))
                        .foregroundStyle(Design.Colors.warning.opacity(0.8))

                    // COPY: unblocked heading — flag for review
                    Text("The block is off.")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Design.Colors.warmWhite)

                    // COPY: unblocked body — flag for review
                    VStack(spacing: 10) {
                        Text("Your streak has been reset.")
                            .font(.subheadline)
                            .foregroundStyle(Design.Colors.warmWhite.opacity(0.55))

                        Text("A fresh start is not a consolation prize. It's what grace looks like.")
                            .font(.body)
                            .foregroundStyle(Design.Colors.warmWhite.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // COPY: unblocked scripture note — flag for review
                    Text("\"Where sin increased, grace increased all the more.\" — Romans 5:20")
                        .font(.footnote.italic())
                        .foregroundStyle(Design.Colors.gold.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 52)
                .padding(.bottom, 24)
            }

            VStack(spacing: 12) {
                // COPY: return to home CTA — flag for review
                Button(action: onDismiss) {
                    Text("Return home")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .primary))

                // COPY: unblocked reinstate note — flag for review
                Text("You can reinstate the block from the home screen at any time.")
                    .font(.footnote)
                    .foregroundStyle(Design.Colors.warmWhite.opacity(0.35))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
