import Foundation

/// Enforces the production publish-block conditions from CLAUDE.md §7.
/// An asset missing any required field — or whose rights are not cleared,
/// or whose review is overdue — must not appear in a production build.
enum EvidenceValidator {

    /// A reason an asset is blocked from production. Empty array = publishable.
    enum BlockReason: Equatable, CustomStringConvertible {
        case missingSourceName
        case missingAttribution
        case missingContentOwner
        case rightsNotCleared(RightsStatus)
        case reviewOverdue(due: Date, now: Date)
        case notPermittedInApp

        var description: String {
            switch self {
            case .missingSourceName: return "sourceName is empty"
            case .missingAttribution:
                return "attribution is empty (use Evidence.attributionNotRequired when not required)"
            case .missingContentOwner: return "contentOwner is empty"
            case .rightsNotCleared(let status): return "rightsStatus=\(status.rawValue) is not clear-to-publish"
            case .reviewOverdue(let due, let now): return "review overdue (due \(due) < now \(now))"
            case .notPermittedInApp: return "permittedUses does not include .inApp"
            }
        }
    }

    /// All reasons this evidence is blocked from production. Empty = OK.
    static func blockReasons(for evidence: Evidence, now: Date = Date()) -> [BlockReason] {
        var reasons: [BlockReason] = []

        if evidence.sourceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            reasons.append(.missingSourceName)
        }
        if evidence.attribution.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            reasons.append(.missingAttribution)
        }
        if evidence.contentOwner.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            reasons.append(.missingContentOwner)
        }
        if !evidence.rightsStatus.isClearToPublish {
            reasons.append(.rightsNotCleared(evidence.rightsStatus))
        }
        if let due = evidence.reviewDueAt, due < now {
            reasons.append(.reviewOverdue(due: due, now: now))
        }
        if !evidence.permittedUses.contains(.inApp) {
            reasons.append(.notPermittedInApp)
        }

        return reasons
    }

    /// Whether a single evidence item may be shown in production.
    static func isPublishable(_ evidence: Evidence, now: Date = Date()) -> Bool {
        blockReasons(for: evidence, now: now).isEmpty
    }

    /// A spot is publishable only when it carries at least one evidence item
    /// and every evidence item is publishable. No unsourced display allowed.
    static func isPublishable(_ spot: Spot, now: Date = Date()) -> Bool {
        guard !spot.evidence.isEmpty else { return false }
        return spot.evidence.allSatisfy { isPublishable($0, now: now) }
    }

    /// Return a copy of `routes` containing only production-safe spots.
    /// Routes left with zero publishable spots are dropped entirely.
    static func productionSafe(_ routes: [Route], now: Date = Date()) -> [Route] {
        routes.compactMap { route in
            let safeSpots = route.spots.filter { isPublishable($0, now: now) }
            guard !safeSpots.isEmpty else { return nil }
            return Route(
                id: route.id,
                title: route.title,
                eraLabel: route.eraLabel,
                isFreePreview: route.isFreePreview,
                productID: route.productID,
                spots: safeSpots
            )
        }
    }
}
