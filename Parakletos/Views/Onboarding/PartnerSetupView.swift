import SwiftUI

struct PartnerSetupView: View {

    @Binding var partnerName: String
    @Binding var partnerPhone: String
    @Binding var passcodeHolder: PasscodeHolder
    let onActivate: () -> Void

    @FocusState private var focusedField: Field?

    private enum Field { case name, phone }

    private var canProceed: Bool {
        !partnerName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !partnerPhone.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            Design.Colors.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Who's in your corner?")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Design.Colors.warmWhite)

                    // COPY: subheading — flag for review
                    Text("This is the man you'll call when it gets hard. His number stays on your phone, never on a server.")
                        .font(.subheadline)
                        .foregroundStyle(Design.Colors.warmWhite.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 8)
                .padding(.horizontal, 24)

                Spacer().frame(height: 40)

                VStack(spacing: 16) {
                    OnboardingField(
                        label: "His name",
                        placeholder: "Brother's name",
                        text: $partnerName,
                        keyboardType: .default,
                        contentType: .name
                    )
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .phone }

                    OnboardingField(
                        label: "His phone number",
                        placeholder: "+1 (555) 000-0000",
                        text: $partnerPhone,
                        keyboardType: .phonePad,
                        contentType: .telephoneNumber
                    )
                    .focused($focusedField, equals: .phone)
                    .submitLabel(.done)
                    .onSubmit { focusedField = nil }
                }
                .padding(.horizontal, 24)

                Spacer()

                NavigationLink {
                    PasscodeHolderView(
                        passcodeHolder: $passcodeHolder,
                        partnerName: partnerName,
                        onActivate: onActivate
                    )
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!canProceed)
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { focusedField = .name }
    }
}

// MARK: - Reusable labelled text field for onboarding

private struct OnboardingField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Design.Colors.gold)
                .textCase(.uppercase)
                .tracking(1)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textContentType(contentType)
                .autocorrectionDisabled()
                .padding(14)
                .background(Design.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Design.Colors.warmWhite)
        }
    }
}
