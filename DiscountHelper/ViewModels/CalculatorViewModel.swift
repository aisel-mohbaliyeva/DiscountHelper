import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {

    // MARK: - User inputs

    @Published var priceText: String = ""
    @Published var discountPercent: Double = 0

    // MARK: - Computed results (read-only)

    @Published private(set) var finalPrice: Double = 0
    @Published private(set) var savedAmount: Double = 0
    @Published private(set) var hasResult: Bool = false
    @Published private(set) var inputError: String? = nil

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        Publishers.CombineLatest($priceText, $discountPercent)
            .debounce(for: .milliseconds(30), scheduler: RunLoop.main)
            .sink { [weak self] text, percent in
                self?.compute(rawText: text, percent: percent)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public interface

    var discountInt: Int { Int(discountPercent) }

    var originalPrice: Double {
        let sanitised = priceText.replacingOccurrences(of: ",", with: ".")
        return Double(sanitised) ?? 0
    }

    func reset() {
        priceText       = ""
        discountPercent = 0
        inputError      = nil
        finalPrice      = 0
        savedAmount     = 0
        hasResult       = false
    }

    func buildRecord(currency: AppCurrency = .azn) -> CalculationRecord? {
        guard hasResult, originalPrice > 0 else { return nil }
        return CalculationRecord(
            originalPrice:   originalPrice,
            discountPercent: discountPercent,
            finalPrice:      finalPrice,
            savedAmount:     savedAmount,
            currencyCode:    currency.rawValue
        )
    }

    // MARK: - Private

    private func compute(rawText: String, percent: Double) {
        inputError = nil
        let clean = rawText.replacingOccurrences(of: ",", with: ".")

        guard !clean.isEmpty else { clearResult(); return }

        guard let price = Double(clean) else {
            inputError = "Please enter a valid number."
            clearResult()
            return
        }

        guard price >= 0 else {
            inputError = "Price can't be negative."
            clearResult()
            return
        }

        let saved  = (price * percent) / 100.0
        let result = price - saved

        finalPrice  = result
        savedAmount = saved
        hasResult   = price > 0
    }

    private func clearResult() {
        finalPrice  = 0
        savedAmount = 0
        hasResult   = false
    }
}

// MARK: - Date formatters

enum Formatter {
    static func shortDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }

    static func longDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        return f.string(from: date)
    }
}
