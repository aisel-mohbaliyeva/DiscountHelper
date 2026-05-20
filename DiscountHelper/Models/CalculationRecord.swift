import Foundation

struct CalculationRecord: Identifiable, Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var originalPrice: Double
    var discountPercent: Double
    var finalPrice: Double
    var savedAmount: Double
    var date: Date = Date()
}
