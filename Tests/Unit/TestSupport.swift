import Foundation
@testable import TimeLens

// MARK: - Fixture loading

enum Fixture {
    /// Load a JSON fixture bundled into the test target.
    static func data(_ name: String) throws -> Data {
        let bundle = Bundle(for: BundleToken.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw NSError(domain: "Fixture", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "missing fixture \(name).json"])
        }
        return try Data(contentsOf: url)
    }

    private final class BundleToken {}
}

// MARK: - Stub repository

struct StubContentRepository: ContentRepository {
    var routes: [Route] = []
    var error: ContentError?

    func loadRoutes(productionSafeOnly: Bool) async throws -> [Route] {
        if let error { throw error }
        return productionSafeOnly ? EvidenceValidator.productionSafe(routes) : routes
    }
}

// MARK: - Model builders

enum Make {
    static func evidence(
        id: String = "ev",
        expressionLevel: ExpressionLevel = .recorded,
        sourceName: String = "資料",
        rightsStatus: RightsStatus = .cleared,
        attribution: String = "提供: テスト",
        permittedUses: [PermittedUse] = [.inApp],
        contentOwner: String = "テスト所有者",
        reviewedAt: Date = Date(timeIntervalSince1970: 1_700_000_000),
        reviewDueAt: Date? = nil
    ) -> Evidence {
        Evidence(
            id: id,
            expressionLevel: expressionLevel,
            sourceName: sourceName,
            rightsStatus: rightsStatus,
            attribution: attribution,
            permittedUses: permittedUses,
            contentOwner: contentOwner,
            reviewedAt: reviewedAt,
            permissionRecordID: nil,
            reviewDueAt: reviewDueAt
        )
    }

    static func spot(
        id: String = "spot",
        isHeroScene: Bool = true,
        evidence: [Evidence] = [Make.evidence()]
    ) -> Spot {
        Spot(
            id: id,
            title: "スポット",
            coordinate: Coordinate(latitude: 35, longitude: 139),
            viewingPoint: ViewingPoint(
                coordinate: Coordinate(latitude: 35, longitude: 139),
                headingDegrees: 90,
                guidance: "立ち止まる",
                guideImageName: nil
            ),
            safety: SafetyRule(safeViewingArea: "歩道", hazards: [], requiresStopConfirmation: true),
            experience: ExperienceDefinition(
                primaryMode: .manualPhoto,
                fallbackModes: [.cinematicFallback],
                isHeroScene: isHeroScene,
                caption: "むかし",
                overlayAssetName: nil,
                ambientAudioName: nil
            ),
            evidence: evidence
        )
    }

    static func route(
        id: String = "route",
        productID: String? = "route.full",
        spots: [Spot] = [Make.spot(id: "hero", isHeroScene: true),
                         Make.spot(id: "paid", isHeroScene: false)]
    ) -> Route {
        Route(
            id: id,
            title: "ルート",
            eraLabel: "昭和",
            isFreePreview: true,
            productID: productID,
            spots: spots
        )
    }
}
