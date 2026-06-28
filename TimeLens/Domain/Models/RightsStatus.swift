import Foundation

/// Rights clearance state for an asset. Only `clearToPublish` states are
/// allowed to surface in a production build (CLAUDE.md §7 公開ブロック条件).
enum RightsStatus: String, Codable, CaseIterable, Equatable {
    /// Explicit permission obtained from the rights holder.
    case cleared
    /// Covered by a license agreement.
    case licensed
    /// Public domain — no permission required.
    case publicDomain
    /// Permission requested but not yet granted. Not publishable.
    case pending
    /// Permission lapsed / revoked. Not publishable.
    case expired
    /// State unknown. Treated as not publishable (fail closed).
    case unknown

    /// Whether this status, on its own, permits production display.
    var isClearToPublish: Bool {
        switch self {
        case .cleared, .licensed, .publicDomain:
            return true
        case .pending, .expired, .unknown:
            return false
        }
    }
}
