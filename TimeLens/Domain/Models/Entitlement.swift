import Foundation

/// A unlocked-content entitlement, derived from StoreKit
/// `Transaction.currentEntitlements` — never from a local UI flag alone
/// (CLAUDE.md §3 StoreKit実装要件).
struct Entitlement: Codable, Identifiable, Equatable {
    /// The StoreKit product identifier that was purchased.
    let productID: String
    /// How the entitlement was established.
    let source: Source

    var id: String { productID }

    enum Source: String, Codable, Equatable {
        case purchased
        case restored
    }
}

/// The set of entitlements currently held, with lock/unlock queries.
struct EntitlementSet: Equatable {
    private let unlockedProductIDs: Set<String>

    init(_ entitlements: [Entitlement]) {
        self.unlockedProductIDs = Set(entitlements.map(\.productID))
    }

    static let empty = EntitlementSet([])

    /// Whether a given route is unlocked for full experience.
    /// A route with no `productID` (fully free) is always unlocked.
    func isUnlocked(_ route: Route) -> Bool {
        guard let productID = route.productID else { return true }
        return unlockedProductIDs.contains(productID)
    }

    /// Whether a specific spot can be experienced given current entitlements.
    /// Hero/free spots are always available; paid spots need the route unlock.
    func canExperience(_ spot: Spot, in route: Route) -> Bool {
        if spot.experience.isHeroScene { return true }
        return isUnlocked(route)
    }
}
