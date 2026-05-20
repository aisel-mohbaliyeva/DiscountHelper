import Foundation

enum CurrencyFormatter {

    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.groupingSeparator = ","
        f.decimalSeparator = "."
        return f
    }()

    static func format(_ value: Double) -> String {
        let symbol = "₼"
        let formatted = formatter.string(from: NSNumber(value: value)) ?? "0.00"
        return "\(symbol) \(formatted)"
    }

    static func plain(_ value: Double) -> String {
        formatter.string(from: NSNumber(value: value)) ?? "0.00"
    }
}
