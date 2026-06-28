import XCTest
@testable import TimeLens

final class ContentDecodingTests: XCTestCase {

    func test_decodesValidDocument() throws {
        let data = try Fixture.data("sample_valid")
        let routes = try BundledContentRepository.decodeRoutes(from: data)

        XCTAssertEqual(routes.count, 1)
        let route = try XCTUnwrap(routes.first)
        XCTAssertEqual(route.id, "route.test.valid")
        XCTAssertEqual(route.spots.count, 1)

        let spot = try XCTUnwrap(route.spots.first)
        XCTAssertTrue(spot.experience.isHeroScene)
        XCTAssertEqual(spot.experience.primaryMode, .manualPhoto)
        XCTAssertEqual(spot.evidence.first?.expressionLevel, .recorded)
        XCTAssertEqual(spot.evidence.first?.attribution, Evidence.attributionNotRequired)
    }

    func test_decodesISO8601Dates() throws {
        let data = try Fixture.data("sample_valid")
        let routes = try BundledContentRepository.decodeRoutes(from: data)
        let reviewedAt = try XCTUnwrap(routes.first?.spots.first?.evidence.first?.reviewedAt)

        let expected = ISO8601DateFormatter().date(from: "2026-06-01T00:00:00Z")
        XCTAssertEqual(reviewedAt, expected)
    }

    func test_malformedDocument_throwsDecodingFailed_doesNotCrash() throws {
        // Missing required key "title" on the route -> recoverable error.
        let data = try Fixture.data("sample_malformed")
        XCTAssertThrowsError(try BundledContentRepository.decodeRoutes(from: data)) { error in
            guard case ContentError.decodingFailed = error else {
                return XCTFail("expected decodingFailed, got \(error)")
            }
        }
    }

    func test_corruptedData_throwsDecodingFailed_doesNotCrash() throws {
        let data = Data("{ this is not json".utf8)
        XCTAssertThrowsError(try BundledContentRepository.decodeRoutes(from: data)) { error in
            guard case ContentError.decodingFailed = error else {
                return XCTFail("expected decodingFailed, got \(error)")
            }
        }
    }

    func test_shippedSampleContent_decodesAndIsPublishable() throws {
        // The content shipped in the app bundle must decode and survive the
        // production rights filter (otherwise the app would have nothing to show).
        let data = try Fixture.data("sample_valid")
        let routes = try BundledContentRepository.decodeRoutes(from: data)
        let safe = EvidenceValidator.productionSafe(routes)
        XCTAssertFalse(safe.isEmpty, "shipped sample must contain publishable content")
    }
}
