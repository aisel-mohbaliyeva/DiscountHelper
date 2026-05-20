import SwiftUI

struct HistoryView: View {

    @EnvironmentObject private var store: HistoryStore
    @State private var selected: CalculationRecord?
    @State private var showClear = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.dhBackground.ignoresSafeArea()

                if store.records.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !store.records.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear All") { showClear = true }
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.red.opacity(0.85))
                    }
                }
            }
            .alert("Clear History", isPresented: $showClear) {
                Button("Delete All", role: .destructive) { store.deleteAll() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("All saved calculations will be permanently removed.")
            }
            .navigationDestination(item: $selected) { record in
                DetailView(record: record)
            }
        }
    }

    private var list: some View {
        List {
            ForEach(store.records) { record in
                HistoryRowView(record: record)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    .contentShape(Rectangle())
                    .onTapGesture { selected = record }
            }
            .onDelete { store.delete(at: $0) }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 56, weight: .thin))
                .foregroundColor(.secondary.opacity(0.35))

            Text("No calculations yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.secondary)

            Text("Use the calculator and save a result\nto see it appear here.")
                .font(.system(size: 14))
                .foregroundColor(.secondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
}
