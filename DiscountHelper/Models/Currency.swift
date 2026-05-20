import Foundation

enum AppCurrency: String, CaseIterable, Codable, Identifiable {
    case azn     = "AZN"
    case usd     = "USD"
    case eur     = "EUR"
    case gbp     = "GBP"
    case tryLira = "TRY"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .azn:     return "₼"
        case .usd:     return "$"
        case .eur:     return "€"
        case .gbp:     return "£"
        case .tryLira: return "₺"
        }
    }

    var displayName: String {
        switch self {
        case .azn:     return "Azerbaijani Manat"
        case .usd:     return "US Dollar"
        case .eur:     return "Euro"
        case .gbp:     return "British Pound"
        case .tryLira: return "Turkish Lira"
        }
    }

    var flag: String {
        switch self {
        case .azn:     return "🇦🇿"
        case .usd:     return "🇺🇸"
        case .eur:     return "🇪🇺"
        case .gbp:     return "🇬🇧"
        case .tryLira: return "🇹🇷"
        }
    }

    func formatted(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.groupingSeparator = ","
        let s = f.string(from: NSNumber(value: value)) ?? "0.00"
        return "\(symbol)\(s)"
    }
}
