import Foundation

/// How faithful an asset is to the historical record (CLAUDE.md §7).
/// Displayed in the UI as 記録 / 再構成 / 演出.
enum ExpressionLevel: String, Codable, CaseIterable, Equatable {
    /// 記録: the source material itself / verified historical record.
    case recorded
    /// 再構成: a reconstruction based on multiple sources.
    case reconstructed
    /// 演出: a dramatised re-creation including mood, people, light, sound.
    case dramatised

    /// Localised label shown to users.
    var displayLabel: String {
        switch self {
        case .recorded: return "記録"
        case .reconstructed: return "再構成"
        case .dramatised: return "演出"
        }
    }
}
