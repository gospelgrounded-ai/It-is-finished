import SwiftUI

struct RepentanceStepView: View {

    let onComplete: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Image(systemName: "arrow.uturn.backward.circle")
                    .font(.system(size: 44, weight: .thin))
                    .foregroundStyle(Design.Colors.gold)

                // COPY: repentance heading — flag for review
                Text("Consider what you're giving up.")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundStyle(Design.Colors.warmWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                // COPY: repentance reflection questions — flag for review
                VStack(alignment: .leading, spacing: 14) {
                    ReflectionLine(text: "What do I think this will give me?")
                    ReflectionLine(text: "What will it actually cost me?")
                    ReflectionLine(text: "Who else is affected by this choice?")
                    ReflectionLine(text: "What does God think of me right now?")
                }
                .padding(.horizontal, 32)

                // COPY: repentance footer note — flag for review
                Text("He is not angry. He is waiting.")
                    .font(.footnote.italic())
                    .foregroundStyle(Design.Colors.gold.opacity(0.7))
            }

            Spacer()

            VStack(spacing: 12) {
                Button(action: onBack) {
                    // COPY: repentance back CTA — flag for review
                    Text("I'm turning back")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .primary))

                Button(action: onComplete) {
                    // COPY: repentance continue — flag for review
                    Text("Continue anyway")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle(style: .secondary))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }
}

private struct ReflectionLine: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .foregroundStyle(Design.Colors.gold)
            Text(text)
                .font(.body)
                .foregroundStyle(Design.Colors.warmWhite.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
