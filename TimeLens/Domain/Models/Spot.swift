import Foundation

/// A single viewing location within a route (CLAUDE.md §7).
struct Spot: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let coordinate: Coordinate
    let viewingPoint: ViewingPoint
    let safety: SafetyRule
    let experience: ExperienceDefinition
    let evidence: [Evidence]
}
