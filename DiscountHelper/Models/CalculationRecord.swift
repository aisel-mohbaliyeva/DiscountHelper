import Foundation

struct CalculationRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var originalPrice: Double
    var discountPercent: Double
    var finalPrice: Double
    var savedAmount: Double
    var date: Date = Date()

    var discountLabel: String {
        "\(Int(discountPercent))% off"
    }
}
