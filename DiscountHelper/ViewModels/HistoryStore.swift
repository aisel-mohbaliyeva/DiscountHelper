import Foundation

final class HistoryStore: ObservableObject {

    @Published private(set) var records: [CalculationRecord] = []

    private let key = "dh_records_v1"

    init() { load() }

    func add(_ record: CalculationRecord) {
        records.insert(record, at: 0)
        persist()
    }

    func delete(at offsets: IndexSet) {
        records.remove(atOffsets: offsets)
        persist()
    }

    func deleteAll() {
        records.removeAll()
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard
            let data    = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode([CalculationRecord].self, from: data)
        else { return }
        records = decoded
    }
}
