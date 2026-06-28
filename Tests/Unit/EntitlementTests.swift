import XCTest
@testable import TimeLens

final class EntitlementTests: XCTestCase {

    func test_emptySet_locksPaidRoute() {
        let route = Make.route(productID: "route.full")
        XCTAssertFalse(EntitlementSet.empty.isUnlocked(route))
    }

    func test_freeRouteWithNoProductID_isAlwaysUnlocked() {
        let route = Make.route(productID: nil)
        XCTAssertTrue(EntitlementSet.empty.isUnlocked(route))
    }

    func test_matchingEntitlement_unlocksRoute() {
        let route = Make.route(productID: "route.full")
        let set = EntitlementSet([Entitlement(productID: "route.full", source: .purchased)])
        XCTAssertTrue(set.isUnlocked(route))
    }

    func test_restoredEntitlement_unlocksRoute() {
        let route = Make.route(productID: "route.full")
        let set = EntitlementSet([Entitlement(productID: "route.full", source: .restored)])
        XCTAssertTrue(set.isUnlocked(route))
    }

    func test_heroSpot_experienceableWithoutPurchase() {
        let hero = Make.spot(id: "hero", isHeroScene: true)
        let route = Make.route(productID: "route.full", spots: [hero])
        XCTAssertTrue(EntitlementSet.empty.canExperience(hero, in: route))
    }

    func test_paidSpot_lockedWithoutPurchase() {
        let paid = Make.spot(id: "paid", isHeroScene: false)
        let route = Make.route(productID: "route.full", spots: [paid])
        XCTAssertFalse(EntitlementSet.empty.canExperience(paid, in: route))
    }

    func test_paidSpot_unlockedAfterPurchase() {
        let paid = Make.spot(id: "paid", isHeroScene: false)
        let route = Make.route(productID: "route.full", spots: [paid])
        let set = EntitlementSet([Entitlement(productID: "route.full", source: .purchased)])
        XCTAssertTrue(set.canExperience(paid, in: route))
    }

    func test_routeFreeAndPaidSplit() {
        let route = Make.route(
            productID: "route.full",
            spots: [Make.spot(id: "h", isHeroScene: true),
                    Make.spot(id: "p1", isHeroScene: false),
                    Make.spot(id: "p2", isHeroScene: false)]
        )
        XCTAssertEqual(route.freeSpots.map(\.id), ["h"])
        XCTAssertEqual(route.paidSpots.map(\.id), ["p1", "p2"])
    }
}
