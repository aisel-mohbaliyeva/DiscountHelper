import SwiftUI

struct HistoryRowView: View {

    let record: CalculationRecord

    private var dateText: String {
        let f = DateFormatter()
        f.dateStyle = .medium
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
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(fmt(record.originalPrice))
                    .font(.dhCaption())
                    .foregroundColor(.secondary)
                    .strikethrough(color: .secondary.opacity(0.5))

                Text(fmt(record.finalPrice))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)

                Text(dateText)
                    .font(.dhCaption())
                    .foregroundColor(.secondary.opacity(0.7))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("\(Int(record.discountPercent))% off")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.dhAccent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.dhAccent.opacity(0.1)))

                Text("-\(fmt(record.savedAmount))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.dhGreen)
            }
        }
        .padding(14)
        .dhCard()
    }
}
