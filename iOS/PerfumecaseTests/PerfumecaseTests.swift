import XCTest
@testable import Perfumecase

@MainActor
final class PerfumecaseTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testAddEntry() {
        let entry = BottleEntry(name: "Test", brand: "A", notes: "B", fillLevel: "")
        store.add(entry)
        XCTAssertEqual(store.entries.count, 1)
    }

    func testDeleteEntry() {
        let entry = BottleEntry(name: "Test", brand: "A", notes: "B", fillLevel: "")
        store.add(entry)
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntry() {
        var entry = BottleEntry(name: "Test", brand: "A", notes: "B", fillLevel: "")
        store.add(entry)
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first?.name, "Updated")
    }

    func testFreeLimitEnforced() {
        for i in 0..<Store.freeLimit {
            store.add(BottleEntry(name: "Item \(i)", brand: "", notes: "", fillLevel: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        store.add(BottleEntry(name: "Overflow", brand: "", notes: "", fillLevel: ""))
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testProUnlocksUnlimited() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(BottleEntry(name: "Item \(i)", brand: "", notes: "", fillLevel: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit + 5)
    }

    func testSeedDataBelowFreeLimit() {
        let fresh = Store()
        XCTAssertLessThan(fresh.entries.count, Store.freeLimit)
    }

    func testDeleteAtOffsets() {
        store.add(BottleEntry(name: "A", brand: "", notes: "", fillLevel: ""))
        store.add(BottleEntry(name: "B", brand: "", notes: "", fillLevel: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.name, "B")
    }

    func testCanAddMoreInitiallyTrue() {
        XCTAssertTrue(store.canAddMore)
    }
}
