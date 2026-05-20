import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CalculatorView()
                .tabItem {
                    Label("Calculator", systemImage: "percent")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(Color.dhAccent)
    }
}
