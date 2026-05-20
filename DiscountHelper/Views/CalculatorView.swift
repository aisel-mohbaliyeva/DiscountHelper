import SwiftUI

struct CalculatorView: View {

    @StateObject private var vm = CalculatorViewModel()
    @EnvironmentObject  private var store: HistoryStore
    @FocusState         private var priceFocused: Bool
    @State              private var savedPulse = false
    @State              private var justSaved  = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.dhBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        priceCard
                        discountCard
                        resultSection
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Discount Helper")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") {
                        withAnimation(.easeOut(duration: 0.25)) {
                            vm.reset()
                            justSaved = false
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.dhAccent)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { priceFocused = false }
                        .foregroundColor(.dhAccent)
                }
            }
        }
    }

    // MARK: - Price Card

    private var priceCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Original Price", systemImage: "dollarsign.circle.fill")
                .font(.dhLabel())
                .foregroundColor(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("₼")
                    .font(.dhPrice())
                    .foregroundColor(.dhAccent)

                TextField("0.00", text: $vm.priceText)
                    .font(.dhPrice())
                    .keyboardType(.decimalPad)
                    .focused($priceFocused)

                if !vm.priceText.isEmpty {
                    Button {
                        vm.priceText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary.opacity(0.4))
                            .font(.system(size: 18))
                    }
                }
            }

            if let err = vm.validationError {
                Text(err)
                    .font(.dhCaption())
                    .foregroundColor(.red.opacity(0.8))
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(18)
        .dhCard()
        .animation(.easeInOut(duration: 0.18), value: vm.validationError)
    }

    // MARK: - Discount Card

    private var discountCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Discount", systemImage: "percent")
                    .font(.dhLabel())
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(vm.discountInt)%")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.dhAccent)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.28), value: vm.discountInt)
            }

            Slider(value: $vm.discountPercent, in: 0...100, step: 1)
                .tint(.dhAccent)

            HStack {
                Text("0%")
                Spacer()
                Text("25%")
                Spacer()
                Text("50%")
                Spacer()
                Text("75%")
                Spacer()
                Text("100%")
            }
            .font(.dhCaption())
            .foregroundColor(.secondary)

            // Quick-pick chips
            HStack(spacing: 8) {
                ForEach([10, 20, 30, 50, 70], id: \.self) { pct in
                    quickChip(pct)
                }
            }
        }
        .padding(18)
        .dhCard()
    }

    private func quickChip(_ pct: Int) -> some View {
        let selected = vm.discountInt == pct
        return Button {
            withAnimation(.spring(response: 0.25)) {
                vm.discountPercent = Double(pct)
            }
        } label: {
            Text("\(pct)%")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(selected ? .white : .dhAccent)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(selected ? Color.dhAccent : Color.dhAccent.opacity(0.1))
                )
        }
        .animation(.easeInOut(duration: 0.15), value: selected)
    }

    // MARK: - Result Section

    @ViewBuilder
    private var resultSection: some View {
        if vm.isResultVisible {
            VStack(spacing: 0) {
                // Blue hero area
                VStack(spacing: 6) {
                    Text("Final Price")
                        .font(.dhLabel())
                        .foregroundColor(.white.opacity(0.75))

                    Text(vm.formattedFinal)
                        .font(.dhHero())
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.38, dampingFraction: 0.72), value: vm.finalPrice)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 26)
                .background(Color.dhAccent)

                // Detail strip
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("You save")
                            .font(.dhLabel())
                            .foregroundColor(.secondary)
                        Text(vm.formattedSaved)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.dhGreen)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.38), value: vm.savedAmount)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("Original")
                            .font(.dhLabel())
                            .foregroundColor(.secondary)
                        Text(vm.formattedOriginal)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.primary)
                            .strikethrough(color: .secondary.opacity(0.5))
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(Color.dhCard)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.dhAccent.opacity(0.28), radius: 14, x: 0, y: 5)
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 0.92).combined(with: .opacity),
                    removal:   .opacity
                )
            )
            .scaleEffect(savedPulse ? 1.015 : 1)
        }
    }

    // MARK: - Save Button

    @ViewBuilder
    private var saveButton: some View {
        if vm.isResultVisible {
            Button {
                guard !justSaved, let record = vm.makeRecord() else { return }
                store.add(record)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) {
                    savedPulse = true
                    justSaved  = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation { savedPulse = false }
                }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: justSaved ? "checkmark.circle.fill" : "square.and.arrow.down")
                        .font(.system(size: 16, weight: .semibold))
                    Text(justSaved ? "Saved to History" : "Save to History")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(justSaved ? .dhGreen : .dhAccent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(justSaved
                              ? Color.dhGreen.opacity(0.1)
                              : Color.dhAccent.opacity(0.09))
                )
            }
            .disabled(justSaved)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }
}
