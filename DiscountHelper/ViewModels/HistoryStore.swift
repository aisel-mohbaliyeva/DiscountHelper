import Foundation

final class HistoryStore: ObservableObject {

    @Published private(set) var records: [CalculationRecord] = []

    private let storageKey = "dh_history_v2"

    init() {
        load()
    }

    func add(_ record: CalculationRecord) {
        records.insert(record, at: 0)
        save()
    }

    func delete(at offsets: IndexSet) {
        records.remove(atOffsets: offsets)
        save()
    }

    func deleteAll() {
        records.removeAll()
        save()
    }

    var isEmpty: Bool { records.isEmpty }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard
            let data    = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode([CalculationRecord].self, from: data)
        else { return }
        records = decoded
    }
}
