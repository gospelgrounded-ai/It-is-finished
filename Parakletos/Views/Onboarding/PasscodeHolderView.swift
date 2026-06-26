import SwiftUI

struct PasscodeHolderView: View {

    @Binding var passcodeHolder: PasscodeHolder
    let partnerName: String
    let onActivate: () -> Void

    var body: some View {
        ZStack {
            Design.Colors.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Who holds the passcode?")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Design.Colors.warmWhite)

                    // COPY: subheading — flag for review
                    Text("The Screen Time passcode is what keeps the block in place. The stronger choice is to let \(partnerName.isEmpty ? "your partner" : partnerName) hold it.")
                        .font(.subheadline)
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 8)
                .padding(.horizontal, 24)

                Spacer().frame(height: 32)

                VStack(spacing: 12) {
                    ForEach(PasscodeHolder.allCases, id: \.self) { choice in
                        PasscodeChoiceCard(
                            choice: choice,
                            isSelected: passcodeHolder == choice
                        ) {
                            passcodeHolder = choice
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                NavigationLink {
                    ActivateView(
                        passcodeHolder: passcodeHolder,
                        partnerName: partnerName,
                        onActivate: onActivate
                    )
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Card

private struct PasscodeChoiceCard: View {
    let choice: PasscodeHolder
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Design.Colors.gold : Design.Colors.warmWhite.opacity(0.3))
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(choice.displayName)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Design.Colors.warmWhite)

                    Text(choice.explanation)
                        .font(.footnote)
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Design.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                isSelected ? Design.Colors.gold : Color.clear,
                                lineWidth: 1.5
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
