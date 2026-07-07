import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [BottleEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier item cap. Always kept well above seed data count so a fresh
    /// install never hits the paywall immediately.
    static let freeLimit = 10

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("Perfumecase", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: BottleEntry) {
        guard canAddMore else { return }
        entries.append(entry)
        save()
    }

    func update(_ entry: BottleEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: BottleEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([BottleEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
        BottleEntry(name: "Aventus", brand: "Aventus", notes: "Creed", fillLevel: ""),
        BottleEntry(name: "Baccarat Rouge 540", brand: "Baccarat Rouge 540", notes: "MFK", fillLevel: ""),
        BottleEntry(name: "Santal 33", brand: "Santal 33", notes: "Le Labo", fillLevel: "")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
