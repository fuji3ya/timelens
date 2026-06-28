import Foundation
import Observation

/// Loads routes and exposes a crash-free loading state. Phase 0 renders a
/// list; Phase 1 adds the MapKit map on top of the same data.
@MainActor
@Observable
final class DiscoverViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded([Route])
        case empty
        case failed(message: String)
    }

    private(set) var state: ViewState = .loading
    private let contentRepository: any ContentRepository

    init(contentRepository: any ContentRepository) {
        self.contentRepository = contentRepository
    }

    var routes: [Route] {
        if case .loaded(let routes) = state { return routes }
        return []
    }

    func load() async {
        state = .loading
        do {
            let routes = try await contentRepository.loadRoutes()
            state = routes.isEmpty ? .empty : .loaded(routes)
            Log.content.info("Loaded \(routes.count, privacy: .public) route(s)")
        } catch {
            // Never crash on bad content — surface a recoverable state and
            // log developer detail (CLAUDE.md §10, §14).
            Log.content.error("Content load failed: \(String(describing: error), privacy: .public)")
            state = .failed(message: Self.userMessage(for: error))
        }
    }

    /// Resolve a spot (and its owning route) by id for navigation.
    func spot(withID id: String) -> (route: Route, spot: Spot)? {
        for route in routes {
            if let spot = route.spots.first(where: { $0.id == id }) {
                return (route, spot)
            }
        }
        return nil
    }

    private static func userMessage(for error: Error) -> String {
        switch error {
        case ContentError.noPublishableContent:
            return "表示できるコンテンツがまだありません。"
        case ContentError.missingResource, ContentError.decodingFailed:
            return "コンテンツを読み込めませんでした。アプリを再起動してお試しください。"
        default:
            return "コンテンツを読み込めませんでした。"
        }
    }
}
