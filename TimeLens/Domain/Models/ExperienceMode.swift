import Foundation

/// The four presentation modes with graceful degradation (CLAUDE.md §5).
/// AR precision failures must never produce a blank/error screen — the
/// experience falls back down this list.
enum ExperienceMode: String, Codable, CaseIterable, Equatable {
    /// Mode A — overlay past photo/illustration on the live camera. P0 floor.
    case manualPhoto
    /// Mode B — limited RealityKit 3D for the Hero Scene. P0.
    case manual3D
    /// Mode C — ARGeoTrackingConfiguration when available. P1.
    case geoTracking
    /// Mode D — cinematic fallback (video/sound/slider) when AR is unusable. P0.
    case cinematicFallback
}
