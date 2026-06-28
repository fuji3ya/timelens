import Foundation
import OSLog

/// Centralised OSLog categories. Developer-facing detail goes here; users
/// only ever see recoverable states (CLAUDE.md §14 エラー対応).
enum Log {
    private static let subsystem = "com.starvingeffort.timelens"

    static let content = Logger(subsystem: subsystem, category: "content")
    static let navigation = Logger(subsystem: subsystem, category: "navigation")
    static let location = Logger(subsystem: subsystem, category: "location")
    static let experience = Logger(subsystem: subsystem, category: "experience")
    static let purchases = Logger(subsystem: subsystem, category: "purchases")
}
