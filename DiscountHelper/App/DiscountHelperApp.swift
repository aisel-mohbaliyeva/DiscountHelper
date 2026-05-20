import SwiftUI

@main
struct DiscountHelperApp: App {

    @StateObject private var historyStore  = HistoryStore()
    @StateObject private var currencyStore = CurrencyStore()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(historyStore)
                .environmentObject(currencyStore)
        }
    }
}
