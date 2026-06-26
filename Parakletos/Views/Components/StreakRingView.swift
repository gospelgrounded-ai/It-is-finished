import SwiftUI

/// Large streak display: number of days inside a gold arc ring.
struct StreakRingView: View {

    let days: Int

    // Ring fills up to 365 days before resetting visually
    private var progress: Double { min(Double(days) / 365.0, 1.0) }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Track
                Circle()
                    .stroke(Design.Colors.surface, lineWidth: 10)
                    .frame(width: 180, height: 180)

                // Fill
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            colors: [Design.Colors.gold.opacity(0.6), Design.Colors.gold],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: days)

                // Number
                VStack(spacing: 0) {
                    Text("\(days)")
                        .font(Design.Typography.streakNumber)
                        .foregroundStyle(Design.Colors.warmWhite)
                        .monospacedDigit()
                        .contentTransition(.numericText())

                    Text(days == 1 ? "day" : "days")
                        .font(Design.Typography.streakLabel)
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.5))
                }
            }

            // COPY: label below ring — flag for review
            Text("standing firm")
                .font(.caption.weight(.medium))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(Design.Colors.gold.opacity(0.7))
        }
    }
}
