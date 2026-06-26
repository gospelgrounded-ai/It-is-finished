import SwiftUI

/// Small icon + value + label pill used on the home screen.
struct StatBadgeView: View {

    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Design.Colors.gold)

            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Design.Colors.warmWhite)
                    .monospacedDigit()
                    .contentTransition(.numericText())

                Text(label)
                    .font(.caption2)
                    .foregroundStyle(Design.Colors.warmWhite.opacity(0.45))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Design.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
