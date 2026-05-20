import SwiftUI

struct HistoryView: View {

    @EnvironmentObject private var store: HistoryStore
    @State private var selectedRecord: CalculationRecord?
    @State private var showClearAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.dhBackground.ignoresSafeArea()

                if store.isEmpty {
                    EmptyStateView(
                        icon:     "clock.arrow.circlepath",
                        title:    "No Calculations Yet",
                        subtitle: "Save a result from the calculator and it will appear here."
                    )
                } else {
                    recordList
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !store.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear All") { showClearAlert = true }
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.red.opacity(0.85))
                    }
                }
            }
            .alert("Clear All History?", isPresented: $showClearAlert) {
                Button("Delete All", role: .destructive) { store.deleteAll() }
                Button("Cancel",     role: .cancel)      { }
            } message: {
                Text("All saved calculations will be permanently removed.")
            }
            .navigationDestination(item: $selectedRecord) { record in
                DetailView(record: record)
            }
        }
    }

    private var recordList: some View {
        List {
            ForEach(store.records) { record in
                HistoryRowView(record: record)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 5, leading: 18, bottom: 5, trailing: 18))
                    .contentShape(Rectangle())
                    .onTapGesture { selectedRecord = record }
            }
            .onDelete { store.delete(at: $0) }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.dhBackground)
    }
}
