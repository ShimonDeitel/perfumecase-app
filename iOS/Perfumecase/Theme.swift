import SwiftUI

/// Bespoke palette for Perfumecase -- Track a fragrance collection with fill levels and notes.
enum Theme {
    static let accent = Color(hex: "#C0447A")
    static let background = Color(hex: "#1B0F16")
    static let backgroundSecondary = Color(hex: "#26141E")
    static let card = Color(hex: "#301A25")
    static let textPrimary = Color(hex: "#F7E9F0")
    static let textSecondary = Color(hex: "#E2AEC7")

    static var titleFont: Font { Font.system(.title2, design: .serif).weight(.semibold) }
    static var bodyFont: Font { Font.system(.body, design: .serif) }
    static var captionFont: Font { Font.system(.caption, design: .serif) }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
