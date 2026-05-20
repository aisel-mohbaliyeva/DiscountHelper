import SwiftUI

struct HistoryRowView: View {

    let record: CalculationRecord

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text(record.currency.formatted(record.originalPrice))
                    .font(.dhCaption())
                    .foregroundStyle(.secondary)
                    .strikethrough(color: .secondary.opacity(0.5))

                Text(record.currency.formatted(record.finalPrice))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(Formatter.shortDate(record.date))
                    .font(.dhCaption())
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(record.discountLabel)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.dhAccent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.dhAccent.opacity(0.10)))

                Text("–\(record.currency.formatted(record.savedAmount))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.dhGreen)
            }
        }
        .padding(14)
        .cardStyle()
    }
}
