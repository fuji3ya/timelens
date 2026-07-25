import XCTest

/// Minimal launch smoke test. Phase 1+ adds onboarding, permission-denied,
/// paywall and restore UI flows (CLAUDE.md §11 UI Tests).
/// `@MainActor`: XCUIApplication and its query APIs are main-actor isolated
/// under Swift 6 strict concurrency.
///
/// Screenshots are attached with `.keepAlways` and exported by CI as an
/// artifact — the only way to SEE the UI from a Windows dev environment.
@MainActor
final class SmokeUITests: XCTestCase {

    func test_launchesAndShowsDiscover_andOpensSpotDetail() {
        let app = XCUIApplication()
        app.launch()

        // The Discover screen's navigation title should appear once the
        // bundled sample content loads.
        XCTAssertTrue(
            app.navigationBars["さがす"].waitForExistence(timeout: 15),
            "Discover screen should be visible on launch"
        )
        attachScreenshot(app, name: "01-discover")

        // Navigate to the Hero Scene's detail via its row.
        let heroRow = app.staticTexts["[SAMPLE] 駅前の大時計"]
        XCTAssertTrue(heroRow.waitForExistence(timeout: 10), "Hero spot row should be listed")
        heroRow.tap()

        XCTAssertTrue(
            app.staticTexts["体験を始める"].waitForExistence(timeout: 10),
            "Spot Detail should show the (disabled) start-experience action"
        )
        attachScreenshot(app, name: "02-spot-detail")
    }

    private func attachScreenshot(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
