import SwiftUI

struct ScriptureCardView: View {

    let entry: ScriptureEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Theme pill
            Text(entry.theme.displayName.uppercased())
                .font(.caption2.weight(.bold))
                .tracking(1.5)
                .foregroundStyle(Design.Colors.gold)

            // Scripture text
            Text(entry.text)
                .font(Design.Typography.scripture)
                .foregroundStyle(Design.Colors.warmWhite)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            // Reference
            Text("— \(entry.reference)")
                .font(Design.Typography.reference)
                .foregroundStyle(Design.Colors.warmWhite.opacity(0.45))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Design.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            // Left accent bar
            RoundedRectangle(cornerRadius: 3)
                .fill(Design.Colors.gold)
                .frame(width: 3)
                .padding(.vertical, 16)
            , alignment: .leading
        )
    }
}
