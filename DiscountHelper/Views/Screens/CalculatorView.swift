import SwiftUI

struct CalculatorView: View {

    @StateObject private var vm = CalculatorViewModel()
    @EnvironmentObject private var store: HistoryStore
    @EnvironmentObject private var currencyStore: CurrencyStore
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var priceFocused: Bool

    @State private var savedToHistory = false
    @State private var cardBump       = false
    @State private var copied         = false

    private let quickPicks = [10, 20, 30, 50, 70]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.dhBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        priceInputCard
                        discountCard
                        if vm.hasResult {
                            resultCard
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.94).combined(with: .opacity),
                                    removal:   .opacity
                                ))
                            saveButton
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 4)
                    .padding(.bottom, 48)
                    .animation(.spring(response: 0.38, dampingFraction: 0.75), value: vm.hasResult)
                }
            }
            .navigationTitle("Discount Helper")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") {
                        withAnimation(.easeOut(duration: 0.22)) {
                            vm.reset()
                            savedToHistory = false
                            copied         = false
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.dhAccent)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { priceFocused = false }
                        .foregroundStyle(Color.dhAccent)
                }
            }
        }
    }

    // MARK: - Price input card

    private var priceInputCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionLabel(icon: "dollarsign.circle.fill", title: "Original Price")

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(currencyStore.selected.symbol)
                    .font(.dhPrice())
                    .foregroundStyle(Color.dhAccent)

                TextField("0.00", text: $vm.priceText)
                    .font(.dhPrice())
                    .keyboardType(.decimalPad)
                    .focused($priceFocused)

                if !vm.priceText.isEmpty {
                    Button {
                        vm.priceText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.secondary.opacity(0.4))
                    }
                    .buttonStyle(.plain)
                }
            }

            if let error = vm.inputError {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 11))
                    Text(error)
                        .font(.dhCaption())
                }
                .foregroundStyle(.red.opacity(0.8))
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(18)
        .cardStyle()
        .animation(.easeInOut(duration: 0.18), value: vm.inputError)
    }

    // MARK: - Discount card

    private var discountCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionLabel(icon: "percent", title: "Discount")
                Spacer()
                Text("\(vm.discountInt)%")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.dhAccent)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.25), value: vm.discountInt)
            }

            Slider(value: $vm.discountPercent, in: 0...100, step: 1)
                .tint(Color.dhAccent)

            HStack {
                ForEach(["0%", "25%", "50%", "75%", "100%"], id: \.self) {
                    Text($0)
                    if $0 != "100%" { Spacer() }
                }
            }
            .font(.dhCaption())
            .foregroundStyle(.tertiary)

            HStack(spacing: 8) {
                ForEach(quickPicks, id: \.self) { value in
                    DiscountChip(
                        value:      value,
                        isSelected: vm.discountInt == value
                    ) {
                        withAnimation(.spring(response: 0.25)) {
                            vm.discountPercent = Double(value)
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
            }
        }
        .padding(18)
        .cardStyle()
    }

    // MARK: - Result card

    private var resultCard: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 6) {
                    Text("Final Price")
                        .font(.dhLabel())
                        .foregroundStyle(.white.opacity(0.75))

                    Text(currencyStore.selected.formatted(vm.finalPrice))
                        .font(.dhHero())
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.38, dampingFraction: 0.7), value: vm.finalPrice)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(LinearGradient.dhBrand)

                Button {
                    UIPasteboard.general.string = currencyStore.selected.formatted(vm.finalPrice)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation(.easeInOut(duration: 0.15)) { copied = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { copied = false }
                    }
                } label: {
                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.72))
                        .padding(9)
                        .background(Circle().fill(.white.opacity(0.12)))
                }
                .buttonStyle(.plain)
                .padding(12)
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("You save")
                        .font(.dhLabel())
                        .foregroundStyle(.secondary)
                    Text(currencyStore.selected.formatted(vm.savedAmount))
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.dhGreen)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.38), value: vm.savedAmount)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("Original")
                        .font(.dhLabel())
                        .foregroundStyle(.secondary)
                    Text(currencyStore.selected.formatted(vm.originalPrice))
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.primary)
                        .strikethrough(color: .secondary.opacity(0.45))
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(Color.dhCard)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(
            color: Color(hex: "3B5BDB").opacity(colorScheme == .dark ? 0.32 : 0.18),
            radius: 14,
            x: 0,
            y: 5
        )
        .scaleEffect(cardBump ? 1.012 : 1)
    }

    // MARK: - Save button

    private var saveButton: some View {
        Button {
            guard !savedToHistory, let record = vm.buildRecord(currency: currencyStore.selected) else { return }
            store.add(record)
            withAnimation(.spring(response: 0.28, dampingFraction: 0.55)) {
                cardBump       = true
                savedToHistory = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                withAnimation { cardBump = false }
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: savedToHistory ? "checkmark.circle.fill" : "arrow.down.circle")
                    .font(.system(size: 16, weight: .semibold))
                Text(savedToHistory ? "Saved to History" : "Save Calculation")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(savedToHistory ? Color.dhGreen : Color.dhAccent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(savedToHistory
                          ? Color.dhGreen.opacity(0.10)
                          : Color.dhAccent.opacity(0.09))
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .strokeBorder(
                                savedToHistory
                                    ? Color.dhGreen.opacity(0.2)
                                    : Color.dhAccent.opacity(0.15),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(savedToHistory)
        .animation(.easeInOut(duration: 0.18), value: savedToHistory)
    }
}
