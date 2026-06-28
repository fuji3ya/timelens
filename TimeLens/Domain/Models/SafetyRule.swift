import Foundation

/// Per-spot safety constraints. Every spot must carry one (CLAUDE.md §8).
struct SafetyRule: Codable, Equatable {
    /// Human description of the safe viewing area.
    let safeViewingArea: String
    /// Known hazards to warn about (車道 / 階段 / 混雑 など).
    let hazards: [String]
    /// Whether the user must explicitly confirm "I am stopped" before AR starts.
    let requiresStopConfirmation: Bool
}
