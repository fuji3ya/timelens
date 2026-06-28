import SwiftUI
import Observation

/// Minimal navigation state for Phase 0. Navigation is value-based on spot
/// id (String) so Domain models need not be Hashable. Richer routes
/// (paywall, experience, library) are added in later phases.
@MainActor
@Observable
final class AppRouter {
    var path = NavigationPath()

    func showSpot(id: String) {
        Log.navigation.debug("navigate to spot \(id, privacy: .public)")
        path.append(id)
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
