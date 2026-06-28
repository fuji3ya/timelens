# TimeLens (仮称)

> いま立っている場所にカメラを向けると、消えた街の記憶が重なる iPhone アプリ。

実装の仕様・優先順位・ルールはすべて [`CLAUDE.md`](CLAUDE.md) を一次情報とする。作業前に必ず全文を読むこと。

## 技術構成
- Swift 6 / SwiftUI / iOS 18+
- ARKit / RealityKit / MapKit / CoreLocation / StoreKit 2
- 外部依存ライブラリ: なし（標準フレームワークのみ）

## ビルド（Mac 不要・CI ビルド前提）
このリポジトリは Windows で著作され、Xcode プロジェクトは **XcodeGen** で生成する。
`.xcodeproj` はコミットしない（`project.yml` が唯一の真実）。

```bash
# macOS 上で
brew install xcodegen
xcodegen generate
xcodebuild -scheme TimeLens -destination 'platform=iOS Simulator,name=iPhone 16' test
```

CI（GitHub Actions macOS runner）が `.github/workflows/ios-build.yml` で同等を実行する。

## 進捗
- [x] Phase 0 — リポジトリ初期化と土台（ドメインモデル / サンプルJSON / Discover→Detail 遷移 / Unit Test）
- [ ] Phase 1 — Discover / Spot Detail / 位置情報
- [ ] Phase 2 — 無料 Hero Scene（Manual Photo Alignment）
- [ ] Phase 3 — Hero Scene の軽量3D化
- [ ] Phase 4 — 有料ルートと StoreKit
- [ ] Phase 5 — ルート体験 / 共有 / 分析
- [ ] Phase 6 — フィールドテストとリリース

## ディレクトリ
`CLAUDE.md` §9 の構成に準拠。`Features → Domain → Infrastructure` の責務境界を崩さない。

## ライセンス / 権利
- 歴史素材・3Dモデル・音声・文章はすべてアセット単位で利用根拠（権利台帳）を持つ。
- `Resources/Content/rights-ledger.sample.json` はサンプルのみ。実台帳はコミットしない。
