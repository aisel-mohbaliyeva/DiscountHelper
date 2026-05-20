import Foundation

struct CalculationRecord: Identifiable, Codable, Hashable {
    var id: UUID
    var originalPrice: Double
    var discountPercent: Double
    var finalPrice: Double
    var savedAmount: Double
    var date: Date
    var currencyCode: String

    init(
        id: UUID = UUID(),
        originalPrice: Double,
        discountPercent: Double,
        finalPrice: Double,
        savedAmount: Double,
        date: Date = Date(),
        currencyCode: String = AppCurrency.azn.rawValue
    ) {
        self.id              = id
        self.originalPrice   = originalPrice
        self.discountPercent = discountPercent
        self.finalPrice      = finalPrice
        self.savedAmount     = savedAmount
        self.date            = date
        self.currencyCode    = currencyCode
    }

    var discountLabel: String { "\(Int(discountPercent))% off" }
    var currency: AppCurrency { AppCurrency(rawValue: currencyCode) ?? .azn }

    // Backward-compatible decoding: records saved before multi-currency support get AZN
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id              = try c.decode(UUID.self,   forKey: .id)
        originalPrice   = try c.decode(Double.self, forKey: .originalPrice)
        discountPercent = try c.decode(Double.self, forKey: .discountPercent)
        finalPrice      = try c.decode(Double.self, forKey: .finalPrice)
        savedAmount     = try c.decode(Double.self, forKey: .savedAmount)
        date            = try c.decode(Date.self,   forKey: .date)
        currencyCode    = (try? c.decode(String.self, forKey: .currencyCode)) ?? AppCurrency.azn.rawValue
    }
}
