import SwiftUI

struct DetailView: View {

    let record: CalculationRecord

    private var dateText: String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        return f.string(from: record.date)
    }

    private func fmt(_ v: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return "₼ \(f.string(from: NSNumber(value: v)) ?? "0.00")"
    }

    var body: some View {
        ZStack {
            Color.dhBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    heroCard
                    breakdownCard
                    shareBtn
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
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
                .foregroundColor(.white.opacity(0.75))

            Text(fmt(record.finalPrice))
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            HStack(spacing: 5) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 13))
                Text("You saved \(fmt(record.savedAmount))")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white.opacity(0.88))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Capsule().fill(.white.opacity(0.18)))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(Color.dhAccent)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.dhAccent.opacity(0.32), radius: 16, x: 0, y: 6)
    }

    // MARK: - Breakdown

    private var breakdownCard: some View {
        VStack(spacing: 0) {
            row(icon: "tag.fill",          label: "Original Price",    value: fmt(record.originalPrice),           color: .primary)
            divider
            row(icon: "percent",            label: "Discount Applied",  value: "\(Int(record.discountPercent))%",   color: .dhAccent)
            divider
            row(icon: "minus.circle.fill",  label: "Amount Saved",      value: fmt(record.savedAmount),             color: .dhGreen)
            divider
            row(icon: "calendar",           label: "Date & Time",       value: dateText,                            color: .secondary)
        }
        .padding(.vertical, 4)
        .dhCard()
    }

    private func row(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.dhAccent)
                .font(.system(size: 16))
                .frame(width: 22)

            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(color)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var divider: some View {
        Divider().padding(.leading, 50)
    }

    // MARK: - Share

    private var shareBtn: some View {
        Button {
            share()
        } label: {
            Label("Share Result", systemImage: "square.and.arrow.up")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.dhAccent)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private func share() {
        let text = """
        Discount Helper
        ─────────────────
        Original price : \(fmt(record.originalPrice))
        Discount       : \(Int(record.discountPercent))%
        You pay        : \(fmt(record.finalPrice))
        You save       : \(fmt(record.savedAmount))
        """
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root  = scene.windows.first?.rootViewController
        else { return }
        root.present(av, animated: true)
    }
}
