import SwiftUI

/// Central design token namespace.
/// Adjust these values to retheme the entire app.
enum Design {

    enum Colors {
        /// Deep navy — primary background
        static let background = Color(red: 0.051, green: 0.067, blue: 0.090)
        /// Elevated surface for cards and fields
        static let surface    = Color(red: 0.102, green: 0.125, blue: 0.180)
        /// Gold accent — streak ring, primary highlights
        static let gold       = Color(red: 0.788, green: 0.659, blue: 0.298)
        /// Warm off-white — body text
        static let warmWhite  = Color(red: 0.961, green: 0.941, blue: 0.910)
        /// Gentle green — positive states, milestones
        static let green      = Color(red: 0.290, green: 0.486, blue: 0.349)
        /// Muted destructive — used only on the override action, never on errors
        static let warning    = Color(red: 0.780, green: 0.300, blue: 0.260)
    }

    enum Typography {
        static let streakNumber = Font.system(size: 72, weight: .bold, design: .rounded)
        static let streakLabel  = Font.system(size: 14, weight: .medium, design: .rounded)
        static let sectionTitle = Font.system(size: 20, weight: .semibold, design: .serif)
        static let scripture    = Font.system(size: 16, weight: .regular, design: .serif)
        static let reference    = Font.system(size: 13, weight: .medium)
    }
}

// MARK: - Shared button style

struct PrimaryButtonStyle: ButtonStyle {
    var style: ButtonVariant = .primary

    enum ButtonVariant { case primary, warning, secondary }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(Design.Colors.warmWhite)
            .padding(.vertical, 16)
            .background(backgroundColor(configuration.isPressed))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }

    private func backgroundColor(_ pressed: Bool) -> Color {
        let base: Color = switch style {
        case .primary:   Design.Colors.gold
        case .warning:   Design.Colors.warning
        case .secondary: Design.Colors.surface
        }
        return pressed ? base.opacity(0.8) : base
    }
}
