import SwiftUI

/// Reused for cooldown1, cooldown2, cooldown3.
/// The "Continue" button is disabled until secondsRemaining == 0.
struct CooldownStepView: View {

    let stepNumber: Int
    let message: String
    let secondsRemaining: Int
    let onContinue: () -> Void

    private var timerDone: Bool { secondsRemaining == 0 }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 28) {
                // Countdown ring
                ZStack {
                    Circle()
                        .stroke(Design.Colors.surface, lineWidth: 8)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: timerDone ? 1 : CGFloat(60 - secondsRemaining) / 60)
                        .stroke(
                            timerDone ? Design.Colors.green : Design.Colors.gold,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: secondsRemaining)

                    if timerDone {
                        Image(systemName: "checkmark")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(Design.Colors.green)
                    } else {
                        Text("\(secondsRemaining)")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(Design.Colors.warmWhite)
                            .monospacedDigit()
                            .contentTransition(.numericText(countsDown: true))
                    }
                }

                Text(message)
                    .font(.body)
                    .foregroundStyle(Design.Colors.warmWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()

            VStack(spacing: 6) {
                if !timerDone {
                    Text("Wait for the timer")
                        .font(.caption)
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.35))
                }

                Button(action: onContinue) {
                    Text(timerDone ? "Continue" : "Continue (\(secondsRemaining)s)")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: timerDone ? .warning : .secondary))
                .disabled(!timerDone)
                .animation(.easeOut, value: timerDone)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }
}
