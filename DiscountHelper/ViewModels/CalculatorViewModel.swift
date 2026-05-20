import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {

    // MARK: - Inputs

    @Published var priceText: String = ""
    @Published var discountPercent: Double = 0

    // MARK: - Outputs

    @Published private(set) var finalPrice: Double = 0
    @Published private(set) var savedAmount: Double = 0
    @Published private(set) var isResultVisible: Bool = false
    @Published private(set) var validationError: String? = nil

    // MARK: - Private

    private var bag = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        Publishers.CombineLatest($priceText, $discountPercent)
            .debounce(for: .milliseconds(40), scheduler: RunLoop.main)
            .sink { [weak self] text, pct in
                self?.recalculate(text: text, percent: pct)
            }
            .store(in: &bag)
    }

    // MARK: - Computed

    var discountInt: Int { Int(discountPercent) }

    var originalPrice: Double {
        Double(priceText.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var formattedFinal: String   { NumberFormatter.currency(finalPrice) }
    var formattedSaved: String   { NumberFormatter.currency(savedAmount) }
    var formattedOriginal: String { NumberFormatter.currency(originalPrice) }

    // MARK: - Logic

    private func recalculate(text: String, percent: Double) {
        validationError = nil
        let sanitised = text.replacingOccurrences(of: ",", with: ".")

        guard !sanitised.isEmpty else {
            clear(); return
        }
        guard let price = Double(sanitised) else {
            validationError = "Enter a valid number."
            clear(); return
        }
        guard price >= 0 else {
            validationError = "Price cannot be negative."
            clear(); return
        }

        let saved  = price * percent / 100.0
        let result = price - saved

        finalPrice     = result
        savedAmount    = saved
        isResultVisible = price > 0
    }

    private func clear() {
        finalPrice      = 0
        savedAmount     = 0
        isResultVisible = false
    }

    func reset() {
        priceText       = ""
        discountPercent = 0
        validationError = nil
        clear()
    }

    func makeRecord() -> CalculationRecord? {
        guard isResultVisible, originalPrice > 0 else { return nil }
        return CalculationRecord(
            originalPrice:  originalPrice,
            discountPercent: discountPercent,
            finalPrice:     finalPrice,
            savedAmount:    savedAmount
        )
    }
}

// MARK: - NumberFormatter helper

private extension NumberFormatter {
    static func currency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle       = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        let s = f.string(from: NSNumber(value: value)) ?? "0.00"
        return "₼ \(s)"
    }
}
