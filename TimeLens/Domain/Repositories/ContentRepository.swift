import Foundation

/// Source of route/spot content. The Domain layer depends on this protocol,
/// not on any concrete bundle/network implementation (CLAUDE.md §9, §4).
/// `Sendable` so a `@MainActor` caller can `await` its nonisolated async
/// methods without risking data races (Swift 6 strict concurrency).
/// Implementations must therefore hold only Sendable state.
protocol ContentRepository: Sendable {
    /// Load every route. Implementations should return only production-safe
    /// content (rights-cleared) when `productionSafeOnly` is true.
    func loadRoutes(productionSafeOnly: Bool) async throws -> [Route]
}

extension ContentRepository {
    /// Convenience: production-safe by default.
    func loadRoutes() async throws -> [Route] {
        try await loadRoutes(productionSafeOnly: true)
    }
}

/// Errors surfaced by content loading. Must never crash the app — callers
/// show a recoverable state and log details to OSLog (CLAUDE.md §14, §10).
enum ContentError: Error, Equatable {
    case missingResource(name: String)
    case decodingFailed(reason: String)
    case noPublishableContent
}
