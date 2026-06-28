import SwiftUI

/// Root of the navigation tree. Phase 0 surfaces the Discover list and a
/// value-based push to Spot Detail. Map (Phase 1), Experience (Phase 2+)
/// and Paywall (Phase 4) plug in here later.
struct RootView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(AppRouter.self) private var router

    @State private var viewModel: DiscoverViewModel?

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            Group {
                if let viewModel {
                    DiscoverView(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationDestination(for: String.self) { spotID in
                if let resolved = viewModel?.spot(withID: spotID) {
                    SpotDetailView(route: resolved.route, spot: resolved.spot)
                } else {
                    ContentUnavailableView(
                        "スポットが見つかりません",
                        systemImage: "mappin.slash",
                        description: Text("コンテンツの読み込みをお試しください。")
                    )
                }
            }
        }
        .task {
            if viewModel == nil {
                let vm = DiscoverViewModel(contentRepository: dependencies.contentRepository)
                viewModel = vm
                await vm.load()
            }
        }
    }
}
