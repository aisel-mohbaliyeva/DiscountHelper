import SwiftUI

struct DetailView: View {

    let record: CalculationRecord
    @State private var copiedPrice = false

    var body: some View {
        ZStack {
            Color.dhBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    heroCard
                    breakdownCard
                    shareButton
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
                .padding(.bottom, 48)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero

    private var heroCard: some View {
        VStack(spacing: 8) {
            Text("Final Price")
                .font(.dhLabel())
                .foregroundStyle(.white.opacity(0.75))

            HStack(alignment: .center, spacing: 10) {
                Text(record.currency.formatted(record.finalPrice))
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Button {
                    UIPasteboard.general.string = record.currency.formatted(record.finalPrice)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation(.easeInOut(duration: 0.15)) { copiedPrice = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { copiedPrice = false }
                    }
                } label: {
                    Image(systemName: copiedPrice ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.65))
                        .padding(8)
                        .background(Circle().fill(.white.opacity(0.12)))
                }
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.15), value: copiedPrice)
            }

            Label(
                "Saved \(record.currency.formatted(record.savedAmount))",
                systemImage: "arrow.down.circle.fill"
            )
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white.opacity(0.88))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Capsule().fill(.white.opacity(0.15)))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(LinearGradient.dhBrand)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color(hex: "3B5BDB").opacity(0.30), radius: 16, x: 0, y: 6)
    }

    // MARK: - Breakdown

    private var breakdownCard: some View {
        VStack(spacing: 0) {
            DetailRow(
                icon:       "tag.fill",
                label:      "Original Price",
                value:      record.currency.formatted(record.originalPrice),
                valueColor: .primary
            )
            RowDivider()
            DetailRow(
                icon:       "percent",
                label:      "Discount Applied",
                value:      record.discountLabel,
                valueColor: Color.dhAccent
            )
            RowDivider()
            DetailRow(
                icon:       "minus.circle.fill",
                label:      "You Saved",
                value:      record.currency.formatted(record.savedAmount),
                valueColor: Color.dhGreen
            )
            RowDivider()
            DetailRow(
                icon:       "calendar",
                label:      "Saved On",
                value:      Formatter.longDate(record.date),
                valueColor: .secondary
            )
        }
        .padding(.vertical, 4)
        .cardStyle()
    }

    // MARK: - Share

    private var shareButton: some View {
        PrimaryButton(
            title:  "Share Result",
            icon:   "square.and.arrow.up",
            color:  Color.dhAccent
        ) {
            presentShareSheet()
        }
    }

    private func presentShareSheet() {
        let cur = record.currency
        let text = """
        Discount Helper
        ──────────────────────
        Original Price : \(cur.formatted(record.originalPrice))
        Discount       : \(record.discountLabel)
        Final Price    : \(cur.formatted(record.finalPrice))
        You Saved      : \(cur.formatted(record.savedAmount))
        """
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root  = scene.windows.first?.rootViewController
        else { return }
        root.present(av, animated: true)
    }
}
