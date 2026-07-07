import Foundation

struct BottleEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var brand: String
    var notes: String
    var fillLevel: String
    var notes: String = ""
    var createdAt: Date = Date()
}
