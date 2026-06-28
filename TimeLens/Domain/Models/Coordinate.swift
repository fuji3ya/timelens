import Foundation

/// A plain geographic coordinate. Kept free of CoreLocation so the Domain
/// layer depends only on the Swift standard library (CLAUDE.md §9).
struct Coordinate: Codable, Equatable, Hashable {
    let latitude: Double
    let longitude: Double
}
