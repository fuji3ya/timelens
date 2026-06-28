import XCTest
@testable import TimeLens

final class ExperienceDefinitionTests: XCTestCase {

    func test_resolvedModeChain_putsPrimaryFirst_andDedupes() {
        let def = ExperienceDefinition(
            primaryMode: .manual3D,
            fallbackModes: [.manual3D, .manualPhoto, .cinematicFallback],
            isHeroScene: true,
            caption: "x",
            overlayAssetName: nil,
            ambientAudioName: nil
        )
        XCTAssertEqual(def.resolvedModeChain, [.manual3D, .manualPhoto, .cinematicFallback])
    }

    func test_hasSafeFallback_trueWhenChainReachesManualPhoto() {
        let def = ExperienceDefinition(
            primaryMode: .geoTracking,
            fallbackModes: [.manualPhoto],
            isHeroScene: false,
            caption: "x",
            overlayAssetName: nil,
            ambientAudioName: nil
        )
        XCTAssertTrue(def.hasSafeFallback)
    }

    func test_hasSafeFallback_falseWhenOnlyPrecisionModes() {
        // A definition that can only ever attempt AR-precision modes violates
        // the §5 絶対ルール — the experience could dead-end. Guard catches it.
        let def = ExperienceDefinition(
            primaryMode: .geoTracking,
            fallbackModes: [.manual3D],
            isHeroScene: false,
            caption: "x",
            overlayAssetName: nil,
            ambientAudioName: nil
        )
        XCTAssertFalse(def.hasSafeFallback)
    }
}
