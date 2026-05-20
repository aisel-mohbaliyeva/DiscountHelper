import SwiftUI

struct SettingsView: View {

    @EnvironmentObject private var currencyStore: CurrencyStore

    var body: some View {
        NavigationStack {
            ZStack {
                Color.dhBackground.ignoresSafeArea()

                List {
                    Section {
                        ForEach(AppCurrency.allCases) { currency in
                            CurrencyRow(
                                currency:   currency,
                                isSelected: currencyStore.selected == currency
                            ) {
                                withAnimation(.easeInOut(duration: 0.18)) {
                                    currencyStore.selected = currency
                                }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                            .listRowBackground(Color.dhCard)
                        }
                    } header: {
                        Text("Currency")
                            .font(.dhCaption())
                            .textCase(nil)
                    }

                    Section {
                        HStack {
                            Label("Version", systemImage: "info.circle")
                                .font(.dhBody())
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("1.0.0")
                                .font(.dhBody())
                                .foregroundStyle(.secondary)
                        }
                        .listRowBackground(Color.dhCard)
                    } header: {
                        Text("About")
                            .font(.dhCaption())
                            .textCase(nil)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Currency row

private struct CurrencyRow: View {
    let currency: AppCurrency
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(currency.flag)
                    .font(.system(size: 22))

                VStack(alignment: .leading, spacing: 2) {
                    Text(currency.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(currency.displayName)
                        .font(.dhCaption())
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.dhAccent)
                        .font(.system(size: 18))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
