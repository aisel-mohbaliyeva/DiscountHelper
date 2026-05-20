import SwiftUI

@main
struct DiscountHelperApp: App {

    @StateObject private var historyStore = HistoryStore()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(historyStore)
        }
    }
}
