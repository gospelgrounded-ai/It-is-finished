import SwiftUI

/// Slides up from the bottom when the user turns back at any confirm step.
/// Auto-dismisses after 4 seconds or on tap.
struct EncouragementBanner: View {

    let message: String
    let onDismiss: () -> Void

    @State private var visible = false

    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 12) {
                Image(systemName: "shield.fill")
                    .foregroundStyle(Design.Colors.gold)

                Text(message)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Design.Colors.warmWhite)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
            .padding(16)
            .background(Design.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Design.Colors.gold.opacity(0.4), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            .offset(y: visible ? 0 : 120)
            .opacity(visible ? 1 : 0)
        }
        .onTapGesture { dismiss() }
        .onAppear {
            withAnimation(.spring(duration: 0.4)) { visible = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { dismiss() }
        }
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.25)) { visible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { onDismiss() }
    }
}
