import Foundation

/// A walkable themed route. The free preview exposes the Hero Scene; the
/// rest unlocks via a non-consumable purchase (CLAUDE.md §3).
struct Route: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    /// Era label shown to users, e.g. "昭和後期の商店街".
    let eraLabel: String
    /// Whether the route offers a free preview (Hero Scene) before purchase.
    let isFreePreview: Bool
    /// StoreKit product identifier that unlocks the paid spots. nil = fully free.
    let productID: String?
    let spots: [Spot]

    /// Spots that are free to experience without an entitlement: the Hero
    /// Scene(s). Everything else requires the route to be unlocked.
    var freeSpots: [Spot] {
        spots.filter { $0.experience.isHeroScene }
    }

    /// Spots gated behind the route purchase.
    var paidSpots: [Spot] {
        spots.filter { !$0.experience.isHeroScene }
    }
}
