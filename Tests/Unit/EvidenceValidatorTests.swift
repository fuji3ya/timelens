import XCTest
@testable import TimeLens

final class EvidenceValidatorTests: XCTestCase {

    func test_clearedEvidence_isPublishable() {
        let evidence = Make.evidence(rightsStatus: .cleared)
        XCTAssertTrue(EvidenceValidator.isPublishable(evidence))
        XCTAssertTrue(EvidenceValidator.blockReasons(for: evidence).isEmpty)
    }

    func test_pendingRights_blocked() {
        let evidence = Make.evidence(rightsStatus: .pending)
        XCTAssertFalse(EvidenceValidator.isPublishable(evidence))
        XCTAssertTrue(EvidenceValidator.blockReasons(for: evidence)
            .contains(.rightsNotCleared(.pending)))
    }

    func test_emptySourceName_blocked() {
        let evidence = Make.evidence(sourceName: "   ")
        XCTAssertTrue(EvidenceValidator.blockReasons(for: evidence).contains(.missingSourceName))
    }

    func test_emptyAttribution_blocked() {
        let evidence = Make.evidence(attribution: "")
        XCTAssertTrue(EvidenceValidator.blockReasons(for: evidence).contains(.missingAttribution))
    }

    func test_notRequiredAttribution_isAllowed() {
        let evidence = Make.evidence(attribution: Evidence.attributionNotRequired)
        XCTAssertTrue(EvidenceValidator.isPublishable(evidence))
    }

    func test_emptyContentOwner_blocked() {
        let evidence = Make.evidence(contentOwner: " ")
        XCTAssertTrue(EvidenceValidator.blockReasons(for: evidence).contains(.missingContentOwner))
    }

    func test_missingInAppPermission_blocked() {
        let evidence = Make.evidence(permittedUses: [.sns, .advertising])
        XCTAssertTrue(EvidenceValidator.blockReasons(for: evidence).contains(.notPermittedInApp))
    }

    func test_overdueReview_blocked() {
        let past = Date(timeIntervalSince1970: 1_600_000_000)
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let evidence = Make.evidence(reviewDueAt: past)
        let reasons = EvidenceValidator.blockReasons(for: evidence, now: now)
        XCTAssertTrue(reasons.contains(.reviewOverdue(due: past, now: now)))
    }

    func test_futureReviewDue_isAllowed() {
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let future = Date(timeIntervalSince1970: 1_800_000_000)
        let evidence = Make.evidence(reviewDueAt: future)
        XCTAssertTrue(EvidenceValidator.isPublishable(evidence, now: now))
    }

    func test_spotWithNoEvidence_isNotPublishable() {
        let spot = Make.spot(evidence: [])
        XCTAssertFalse(EvidenceValidator.isPublishable(spot))
    }

    func test_productionSafe_dropsRouteWhenAllSpotsBlocked() {
        let blocked = Make.spot(id: "b", evidence: [Make.evidence(rightsStatus: .expired)])
        let route = Make.route(spots: [blocked])
        XCTAssertTrue(EvidenceValidator.productionSafe([route]).isEmpty)
    }

    func test_productionSafe_keepsOnlyPublishableSpots() {
        let ok = Make.spot(id: "ok", evidence: [Make.evidence(rightsStatus: .cleared)])
        let bad = Make.spot(id: "bad", evidence: [Make.evidence(rightsStatus: .pending)])
        let route = Make.route(spots: [ok, bad])
        let safe = EvidenceValidator.productionSafe([route])
        XCTAssertEqual(safe.first?.spots.map(\.id), ["ok"])
    }
}
