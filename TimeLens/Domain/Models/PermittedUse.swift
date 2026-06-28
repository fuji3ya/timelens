import Foundation

/// The contexts an asset is permitted to be used in (CLAUDE.md §7 権利台帳).
enum PermittedUse: String, Codable, CaseIterable, Equatable {
    case inApp
    case advertising
    case sns
    case event
    case overseas
}
