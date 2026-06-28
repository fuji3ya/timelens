import SwiftUI

/// Phase 0 Spot Detail: shows the spot's intro, viewing point, safety notes
/// and evidence labels (記録/再構成/演出). The "体験を始める" action is wired
/// in Phase 2 (Experience); here it is shown disabled as a placeholder so the
/// flow is visible without faking behaviour (CLAUDE.md §14).
struct SpotDetailView: View {
    let route: Route
    let spot: Spot

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                section("観覧位置", systemImage: "figure.stand") {
                    Text(spot.viewingPoint.guidance)
                }
                section("安全のために", systemImage: "exclamationmark.shield") {
                    Text(spot.safety.safeViewingArea)
                    if !spot.safety.hazards.isEmpty {
                        Text("注意: " + spot.safety.hazards.joined(separator: " / "))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                section("資料", systemImage: "doc.text.magnifyingglass") {
                    ForEach(spot.evidence) { evidence in
                        EvidenceRow(evidence: evidence)
                    }
                }
                startButton
            }
            .padding()
        }
        .navigationTitle(spot.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(route.eraLabel)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(spot.experience.caption)
                .font(.title3)
                .fontWeight(.medium)
        }
    }

    private var startButton: some View {
        VStack(spacing: 8) {
            Button {
                // Wired in Phase 2 (Experience).
            } label: {
                Label("体験を始める", systemImage: "camera.viewfinder")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(true)

            Text("AR体験は Phase 2 で実装予定（PLACEHOLDER）")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.top, 8)
    }

    private func section(
        _ title: String,
        systemImage: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct EvidenceRow: View {
    let evidence: Evidence

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(evidence.expressionLevel.displayLabel)
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(.thinMaterial, in: Capsule())
            VStack(alignment: .leading, spacing: 2) {
                Text(evidence.sourceName)
                    .font(.subheadline)
                if evidence.attribution != Evidence.attributionNotRequired {
                    Text(evidence.attribution)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
