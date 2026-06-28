import XCTest
@testable import TimeLens

@MainActor
final class DiscoverViewModelTests: XCTestCase {

    func test_load_success_setsLoaded() async {
        let repo = StubContentRepository(routes: [Make.route()])
        let vm = DiscoverViewModel(contentRepository: repo)
        await vm.load()

        guard case .loaded(let routes) = vm.state else {
            return XCTFail("expected loaded, got \(vm.state)")
        }
        XCTAssertEqual(routes.count, 1)
    }

    func test_load_emptyContent_setsEmpty() async {
        let repo = StubContentRepository(routes: [])
        let vm = DiscoverViewModel(contentRepository: repo)
        await vm.load()
        XCTAssertEqual(vm.state, .empty)
    }

    func test_load_error_setsFailed_doesNotCrash() async {
        let repo = StubContentRepository(error: .missingResource(name: "routes.json"))
        let vm = DiscoverViewModel(contentRepository: repo)
        await vm.load()

        guard case .failed = vm.state else {
            return XCTFail("expected failed, got \(vm.state)")
        }
    }

    func test_spotLookup_resolvesByID() async {
        let repo = StubContentRepository(routes: [Make.route()])
        let vm = DiscoverViewModel(contentRepository: repo)
        await vm.load()

        let resolved = vm.spot(withID: "hero")
        XCTAssertEqual(resolved?.spot.id, "hero")
        XCTAssertEqual(resolved?.route.id, "route")
        XCTAssertNil(vm.spot(withID: "does-not-exist"))
    }
}
