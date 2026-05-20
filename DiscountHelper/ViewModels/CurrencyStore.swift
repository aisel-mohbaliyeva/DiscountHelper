import Foundation

final class CurrencyStore: ObservableObject {

    @Published var selected: AppCurrency {
        didSet {
            UserDefaults.standard.set(selected.rawValue, forKey: storageKey)
        }
    }

    private let storageKey = "dh_currency_v1"

    init() {
        let raw = UserDefaults.standard.string(forKey: "dh_currency_v1") ?? AppCurrency.azn.rawValue
        selected = AppCurrency(rawValue: raw) ?? .azn
    }
}
