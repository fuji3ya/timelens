import Foundation
import Observation

/// Composition root. Concrete infrastructure is wired here and injected into
/// the view tree, so Features depend on protocols, not implementations
/// (CLAUDE.md §9 依存性ルール).
@MainActor
@Observable
final class AppDependencies {
    let contentRepository: any ContentRepository

    init(contentRepository: any ContentRepository) {
        self.contentRepository = contentRepository
    }

    /// Production wiring: bundle-backed content, no network (CLAUDE.md §4).
    static func live() -> AppDependencies {
        AppDependencies(contentRepository: BundledContentRepository())
    }
}
