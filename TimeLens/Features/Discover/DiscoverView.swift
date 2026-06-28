import SwiftUI

/// Phase 0 Discover surface: a list of routes and their spots. The MapKit
/// map (Phase 1) will layer onto this same view model. The list must always
/// remain reachable so the experience never depends on the map alone
/// (CLAUDE.md §6 Discover Map, Phase 1 完了条件).
struct DiscoverView: View {
    @Environment(AppRouter.self) private var router
    let viewModel: DiscoverViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("読み込み中…")
            case .empty:
                ContentUnavailableView(
                    "スポットがありません",
                    systemImage: "mappin.slash",
                    description: Text("公開できるコンテンツがまだ登録されていません。")
                )
            case .failed(let message):
                ContentUnavailableView {
                    Label("読み込みエラー", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    Button("再試行") { Task { await viewModel.load() } }
                }
            case .loaded(let routes):
                routeList(routes)
            }
        }
        .navigationTitle("さがす")
    }

    private func routeList(_ routes: [Route]) -> some View {
        List {
            ForEach(routes) { route in
                Section {
                    ForEach(route.spots) { spot in
                        Button {
                            router.showSpot(id: spot.id)
                        } label: {
                            SpotRow(spot: spot)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    RouteHeader(route: route)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct RouteHeader: View {
    let route: Route

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(route.title)
                .font(.headline)
            Text(route.eraLabel)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .textCase(nil)
        .padding(.vertical, 4)
    }
}

private struct SpotRow: View {
    let spot: Spot

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: spot.experience.isHeroScene ? "star.circle.fill" : "mappin.circle")
                .foregroundStyle(spot.experience.isHeroScene ? .yellow : .accentColor)
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(spot.title)
                    .font(.body)
                Text(spot.experience.isHeroScene ? "無料で体験できます" : "ルート購入で解放")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
