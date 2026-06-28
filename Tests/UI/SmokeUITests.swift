import XCTest

/// Minimal launch smoke test. Phase 1+ adds onboarding, permission-denied,
/// paywall and restore UI flows (CLAUDE.md §11 UI Tests).
/// `@MainActor`: XCUIApplication and its query APIs are main-actor isolated
/// under Swift 6 strict concurrency.
@MainActor
final class SmokeUITests: XCTestCase {

    func test_launchesAndShowsDiscover() {
        let app = XCUIApplication()
        app.launch()
        // The Discover screen's navigation title should appear once the
        // bundled sample content loads.
        XCTAssertTrue(
            app.navigationBars["さがす"].waitForExistence(timeout: 15),
            "Discover screen should be visible on launch"
        )
    }
}
