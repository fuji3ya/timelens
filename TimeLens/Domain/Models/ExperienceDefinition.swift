import Foundation

/// Describes how a spot is experienced and which fallback modes it supports.
/// Concrete AR/asset wiring is added in later phases; Phase 0 models the
/// contract so content and the experience engine can be built independently.
struct ExperienceDefinition: Codable, Equatable {
    /// Preferred mode to attempt first.
    let primaryMode: ExperienceMode
    /// Ordered fallback chain. Must always be able to reach a P0 mode
    /// (manualPhoto or cinematicFallback) so the experience never dead-ends.
    let fallbackModes: [ExperienceMode]
    /// Whether this is the route's Hero Scene (strongest single change).
    let isHeroScene: Bool
    /// Short emotional caption (一画面70〜120文字目安, CLAUDE.md §6).
    let caption: String
    /// Optional bundled overlay asset (image/usdz) name. Resolved per mode later.
    let overlayAssetName: String?
    /// Optional bundled ambient audio name.
    let ambientAudioName: String?

    /// The full ordered list of modes that may be presented, primary first.
    var resolvedModeChain: [ExperienceMode] {
        var chain = [primaryMode]
        for mode in fallbackModes where !chain.contains(mode) {
            chain.append(mode)
        }
        return chain
    }

    /// True when the chain can reach a mode that needs no GPS/AR precision,
    /// i.e. the experience can always present something (CLAUDE.md §5 絶対ルール).
    var hasSafeFallback: Bool {
        resolvedModeChain.contains(.manualPhoto)
            || resolvedModeChain.contains(.cinematicFallback)
    }
}
