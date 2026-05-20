import SwiftUI

struct HistoryRowView: View {

    let record: CalculationRecord

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Left: prices + date
            VStack(alignment: .leading, spacing: 3) {
                Text(Formatter.price(record.originalPrice))
                    .font(.dhCaption())
                    .foregroundStyle(.secondary)
                    .strikethrough(color: .secondary.opacity(0.5))

                Text(Formatter.price(record.finalPrice))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(Formatter.shortDate(record.date))
                    .font(.dhCaption())
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            // Right: discount badge + saved
            VStack(alignment: .trailing, spacing: 6) {
                Text(record.discountLabel)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.dhAccent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.dhAccent.opacity(0.10)))

                Text("–\(Formatter.price(record.savedAmount))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.dhGreen)
            }
        }
        .padding(14)
        .cardStyle()
    }
}
