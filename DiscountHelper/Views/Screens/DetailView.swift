import SwiftUI

struct DetailView: View {

    let record: CalculationRecord

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

            Text(Formatter.price(record.finalPrice))
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Label(
                "You saved \(Formatter.price(record.savedAmount))",
                systemImage: "arrow.down.circle.fill"
            )
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white.opacity(0.88))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Capsule().fill(.white.opacity(0.18)))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(Color.dhAccent)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.dhAccent.opacity(0.30), radius: 14, x: 0, y: 6)
    }

    // MARK: - Breakdown

    private var breakdownCard: some View {
        VStack(spacing: 0) {
            DetailRow(icon: "tag.fill",         label: "Original Price",   value: Formatter.price(record.originalPrice), valueColor: .primary)
            RowDivider()
            DetailRow(icon: "percent",           label: "Discount Applied", value: record.discountLabel,                  valueColor: Color.dhAccent)
            RowDivider()
            DetailRow(icon: "minus.circle.fill", label: "You Saved",        value: Formatter.price(record.savedAmount),   valueColor: Color.dhGreen)
            RowDivider()
            DetailRow(icon: "calendar",          label: "Saved On",         value: Formatter.longDate(record.date),       valueColor: .secondary)
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
        let text = """
        Discount Helper Result
        ──────────────────────
        Original Price : \(Formatter.price(record.originalPrice))
        Discount       : \(record.discountLabel)
        Final Price    : \(Formatter.price(record.finalPrice))
        You Saved      : \(Formatter.price(record.savedAmount))
        """
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root  = scene.windows.first?.rootViewController
        else { return }
        root.present(av, animated: true)
    }
}
